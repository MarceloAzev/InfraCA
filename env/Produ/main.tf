module "aws-prod"{
    source = "../../infra"
    instancia_tipo = "t2.micro"
    regiao_us_aws = "us-east-1"
    chave = "iac"
    amis = "ami-0fc5d935ebf8bc3bc"
    instancia_name = "prod01"
    name_vpc = "prod-vpc"
    name_ig = "prod-ig"      
    name_sbnt = "prod-sbnt"  
    name_route = "prod-route"
    name_acl = "prod-acl"
    name_sg = "prod-sg"
    minimo = 1
    maximo = 10
    name_escalonamento = "Prod"
    producao = true
}