resource "aws_instance" "APP01" {
    ami           = var.amis["us-east-1"]
    instance_type = "t2.micro"
    key_name = var.key-name
    vpc_security_group_ids = ["${aws_security_group.acesso_ssh.id}"]
    tags = {
        Name = "APP-01"
    }
}