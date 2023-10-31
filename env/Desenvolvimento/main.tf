module "aws-dev"{
    source = "../../infra"
    instancia_tipo = "t2.micro"
    regiao_us_aws = "us-east-1"
    chave = "iac-estudo"
    amis = "ami-0fc5d935ebf8bc3bc"
    instancia_name = "Dev01"
}
output "IP"{
    value = module.aws-dev.IP_publico
}