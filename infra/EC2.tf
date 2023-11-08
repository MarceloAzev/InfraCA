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

#-----------------------Load Balance-----------------------
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

resource "aws_lb" "loadBalance"{
  internal = false
  subnets = [ aws_subnet.subnet-a.id, aws_subnet.subnet-b.id]
  security_groups = [aws_security_group.acesso_geral.id]
}

resource "aws_lb_target_group" "alvoLoadBalance"{
  name = "destinoMaquina"
  port = "8080"
  protocol = "HTTP"
  vpc_id = aws_vpc.terraform-estudo.id
}

resource "aws_lb_listener" "entradaLoadBalance"{
  load_balancer_arn = aws_lb.loadBalance.arn
  port = "8080"
  protocol = "HTTP"
  default_action{
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalance.arn
  }

}

resource "aws_autoscaling_policy" "escalonamento"{
    name = "terraform-escala"
    autoscaling_group_name = var.name_escalonamento
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration{
        predefined_metric_specification{
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
}
#-----------------------Load Balance-----------------------