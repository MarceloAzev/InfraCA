resource "aws_instance" "APP01" {
    ami           = var.amis["us-east-1"]
    instance_type = "t2.micro"
    key_name = var.key-name
    vpc_security_group_ids = ["${aws_security_group.acesso_ssh.id}"]
    # user_data = <<-OEF
    #             #!/bin/bash
    #             cd /home/ubuntu
    #             echo "<h1> Ola mundo Feito com terraform </h1>" > index.html
    #             nohup busybox httpd -f -p 8080 &
    #             OEF
    tags = {
        Name = "terraform ansible python"
    }
}