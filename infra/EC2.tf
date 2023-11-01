#-----------------------------Template Instancia-----------------------------
resource "aws_launch_template" "servidor" {
    image_id = var.amis #mesma função do ami em instancia
    instance_type = var.instancia_tipo
    key_name = var.chave
    security_group_names = [var.name_sg]
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
    availability_zones = [ "${var.regiao_us_aws}a" ]
    name = var.name_escalonamento
    max_size = var.maximo
    min_size = var.minimo
    launch_template{
        id = aws_launch_template.servidor.id
        version = "$Latest"
    }
}
#-----------------------------grupo de escalonamento-----------------------------