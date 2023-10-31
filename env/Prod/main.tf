module "aws-Prod"{
    source = "../../infra"
    instancia_tipo = "t2.micro"
    regiao_us_aws = "us-east-2"
    chave = "iac"
    amis = "ami-0e83be366243f524a"
    instancia_name = "Prod02"
}

output "IP"{
    value = module.aws-prod.IP_publico
}