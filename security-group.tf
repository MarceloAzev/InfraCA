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
    cidr_blocks      =  var.cdirs_acesso_remoto
  }

  tags = {
    Name = "ssh e web-serve port"
  }
}