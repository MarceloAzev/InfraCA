variable "amis"{
    type = string
}
variable "instancia_tipo"{
    type = string
}

variable "chave"{
    type = string
}

variable "cdirs_acesso_remoto"{
    type = list
    default = ["187.112.141.4/32"]

}

variable "regiao_us_aws" {
    type = string

}

variable "instancia_name"{
    type = string
}

