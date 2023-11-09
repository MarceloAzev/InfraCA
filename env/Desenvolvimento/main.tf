module "aws-dev"{
    source = "../../infra"
    instancia_tipo = "t2.micro"
    regiao_us_aws = "us-east-1"
    chave = "iac-estudo"
    amis = "ami-0fc5d935ebf8bc3bc"
    instancia_name = "Dev01"
    name_vpc = "dev-vpc"
    name_ig = "dev-ig"      
    name_sbnt = "dev-sbnt"  
    name_route = "dev-route"
    name_acl = "dev-acl"
    name_sg = "dev-sg"
    minimo = 0
    maximo = 1
    name_escalonamento = "Dev"
    producao = false
}