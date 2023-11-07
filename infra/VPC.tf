#-----------------------VPC-----------------------
resource "aws_vpc" "terraform-estudo" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = var.name_vpc
  }
}
#-----------------------VPC-----------------------

#-----------------------internet gateway-----------------------
resource "aws_internet_gateway" "internet-acesso" {
  vpc_id = aws_vpc.terraform-estudo.id
  tags = {
    Name = var.name_ig
  }
}
#-----------------------internet gateway-----------------------
#-----------------------SUBNET-----------------------
resource "aws_subnet" "subnet-a" {
  # availability_zones = [ "${var.regiao_us_aws}a"]
  vpc_id     = aws_vpc.terraform-estudo.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = var.name_sbnt
  } 
}

# resource "aws_subnet" "subnet-b" {
#   # availability_zones = [ "${var.regiao_us_aws}b"]
#   vpc_id     = aws_vpc.terraform-estudo.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "1b"

#   tags = {
#     Name = "${var.name_sbnt}-b"
#   } 
# }
#-----------------------SUBNET-----------------------

#-----------------------Load Balance-----------------------
# resource "aws_lb" "loadBalance"{
#   internal = false
#   subnets = [ aws_subnet.subnet-a.id, aws_subnet.subnet-b.id]
#   security_groups = [aws_security_group.acesso_geral.id]
# }

# resource "aws_lb_target_group" "alvoLoadBalance"{
#   name = "destinoMaquina"
#   port = "8080"
#   protocol = "HTTP"
#   vpc_id = aws_vpc.terraform-estudo.id
# }

# resource "aws_lb_listener" "entradaLoadBalance"{
#   load_balancer_arn = aws_lb.loadBalance.arn
#   port = "8080"
#   protocol = "HTTP"
#   default_action{
#     type = "forward"
#     target_group_arn = aws_lb_target_group.alvoLoadBalance.arn
#   }

# }
#-----------------------Load Balance-----------------------


#-----------------------route table-----------------------
resource "aws_route_table" "route-public-a" {
  vpc_id = aws_vpc.terraform-estudo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-acesso.id
  }
  tags = {
    Name = var.name_route
  }
}
#-----------------------route table-----------------------

#-----------------------acl-----------------------
resource "aws_network_acl" "terraform-acl" {
  vpc_id = aws_vpc.terraform-estudo.id

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "-1"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
   ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
   ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "-1"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = var.name_acl
  }
}
#-----------------------acl-----------------------

#-----------------------Security Group------------------------------
resource "aws_security_group" "acesso_geral" {
  name        = var.name_sg
  vpc_id      = aws_vpc.terraform-estudo.id
  ingress {
    description      = "SSH port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      =  var.cdirs_acesso_remoto
  }
  ingress {
    description      = "web-serve port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      =  ["0.0.0.0/0"]
  }
  ingress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      =  ["0.0.0.0/0"]
  }
  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      =  ["0.0.0.0/0"]
  }
 
  egress {
    description      = "SSH port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      =  var.cdirs_acesso_remoto
  }
  egress {
    description      = "Web-server port"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      =  ["0.0.0.0/0"]
  }
  egress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description      = "https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  

  tags = {
    Name = var.name_sg
  }
}
# -----------------------Security Group-----------------------

#-----------------------Association-----------------------
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-a.id
  route_table_id = aws_route_table.route-public-a.id
}
resource "aws_network_acl_association" "acl-sub" {
  network_acl_id = aws_network_acl.terraform-acl.id
  subnet_id      = aws_subnet.subnet-a.id
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.terraform-estudo.id
  route_table_id = aws_route_table.route-public-a.id
}
#-----------------------Association-----------------------

