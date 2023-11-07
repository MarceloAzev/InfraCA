#-----------------------------Template Instancia-----------------------------
resource "aws_launch_template" "servidor" {
    image_id = var.amis #mesma função do ami em instancia
    instance_type = var.instancia_tipo
    key_name = var.chave
    network_interfaces {
        associate_public_ip_address = true
        delete_on_termination       = true
        security_groups = ["${aws_security_group.acesso_geral.id}"]
  }
    tags = {
        Name = var.instancia_name
    }
    user_data = filebase64("ansible.sh")
}
#-----------------------------Template Instancia-----------------------------

#-----------------------------Chave-----------------------------
resource "aws_key_pair" "chaveSSH"{
    key_name = var.chave
    public_key = file("${var.chave}.pub")
}
#-----------------------------Chave-----------------------------

#-----------------------------grupo de escalonamento-----------------------------
resource "aws_autoscaling_group" "escalonamento"{
    vpc_zone_identifier = [ aws_subnet.subnet-a.id,aws_subnet.subnet-b.id ]
    name = var.name_escalonamento
    max_size = var.maximo
    min_size = var.minimo
    launch_template{
        id = aws_launch_template.servidor.id
        version = "$Latest"
    }
    target_group_arns = [aws_lb_target_group.alvoLoadBalance.arn]
}
#-----------------------------grupo de escalonamento-----------------------------