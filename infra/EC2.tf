#-----------------------------Instancia-----------------------------
resource "aws_instance" "srv" {
    ami           = var.amis
    instance_type = var.instancia_tipo
    key_name = var.chave
    vpc_security_group_ids = ["${aws_security_group.acesso_ssh.id}"]
    tags = {
        Name = var.instancia_name
    }
}
#-----------------------------Instancia-----------------------------

#-----------------------------Chave-----------------------------
resource "aws_key_pair" "chaveSSH"{
    key_name = var.chave
    public_key = file("${var.chave}.pub")
}
#-----------------------------Chave-----------------------------

#-----------------------------output-----------------------------
output "IP_publico"{
    value = aws_instance.srv.public_ip
}