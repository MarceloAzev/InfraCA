resource "aws_instance" "APP01" {
    ami           = var.amis["us-east-1"]
    instance_type = "t2.micro"

    tags = {
        Name = "APP-01"
    }
}