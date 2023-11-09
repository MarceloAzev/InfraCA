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
    user_data = var.producao ? filebase64("ansible.sh") : ""
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
    target_group_arns = var.producao ? [aws_lb_target_group.alvoLoadBalance[0].arn] : []
}

resource "aws_autoscaling_schedule" "start" {
  scheduled_action_name  = "start"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  start_time             = timeadd(timestamp(),"10m")
  #end_time               = "2016-12-12T06:00:00Z" tempo para parar o funcinamento do agendamento
  recurrence             = "0 10 * * mon-fri"  # fusso horário de greenwich
  autoscaling_group_name = aws_autoscaling_group.escalonamento.name
}

resource "aws_autoscaling_schedule" "stop" {
  scheduled_action_name  = "stop"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 0
  start_time             = timeadd(timestamp(),"11m")
  #end_time               = "2016-12-12T06:00:00Z" tempo para parar o funcinamento do agendamento
  recurrence             = "30 14 * * mon-fri" # fusso horário de greenwich
  autoscaling_group_name = aws_autoscaling_group.escalonamento.name
}

resource "aws_lb" "loadBalance"{
  internal = false
  subnets = [ aws_subnet.subnet-a.id, aws_subnet.subnet-b.id]
  security_groups = [aws_security_group.acesso_geral.id]
  count = var.producao ? 1 : 0
}

resource "aws_lb_target_group" "alvoLoadBalance"{
  name = "destinoMaquina"
  port = "8080"
  protocol = "HTTP"
  vpc_id = aws_vpc.terraform-estudo.id
  count = var.producao ? 1 : 0 #caso não seja criado o LB e ele tentar criar o group acaba dando erro na hora de subir, por isso a necessidade de ter um count
}

resource "aws_lb_listener" "entradaLoadBalance"{
  load_balancer_arn = aws_lb.loadBalance[0].arn
  port = "8080"
  protocol = "HTTP"
  default_action{
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalance[0].arn
  }
  count = var.producao ? 1 : 0 #caso não seja criado o LB e ele tentar criar o group acaba dando erro na hora de subir, por isso a necessidade de ter um count
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
    count = var.producao ? 1 : 0 #evitar de tentar ficar subindo instância no ambiente de teste/dev
    depends_on = [
    aws_autoscaling_group.escalonamento
  ]
}
#-----------------------Load Balance-----------------------