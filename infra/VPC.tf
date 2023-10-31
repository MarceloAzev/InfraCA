#-----------------------VPC-----------------------
resource "aws_vpc" "terraform-estudo" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "iac-estudo"
  }
}
#-----------------------VPC-----------------------

#-----------------------internet gateway-----------------------
resource "aws_internet_gateway" "internet-acesso" {
  vpc_id = aws_vpc.terraform-estudo.id

  tags = {
    Name = "internet"
  }
}
#-----------------------internet gateway-----------------------
#-----------------------SUBNET-----------------------
resource "aws_subnet" "subnet-a" {
  vpc_id     = aws_vpc.terraform-estudo.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet-a"
  } 
}
#-----------------------SUBNET-----------------------

#-----------------------route table-----------------------
resource "aws_route_table" "route-public-a" {
  vpc_id = aws_vpc.terraform-estudo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-acesso.id
  }
  tags = {
    Name = "route-public"
  }
  depends_on = [
    aws_internet_gateway.internet-acesso
  ]
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

  tags = {
    Name = "terraform-acl"
  }
}
#-----------------------acl-----------------------

#-----------------------Security Group------------------------------
resource "aws_security_group" "acesso_ssh" {
  name        = "acesso_ssh"
  description = "acesso_ssh"

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
    Name = "ssh e web-serve port"
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
#-----------------------Association-----------------------

