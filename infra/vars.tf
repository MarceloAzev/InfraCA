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
    default = ["177.41.208.72/32"]

}

variable "regiao_us_aws" {
    type = string

}

variable "instancia_name"{
    type = string
}

variable "name_vpc"{
    type = string
}

variable "name_ig"{
    type = string
}

variable "name_sbnt"{
    type = string
}

variable "name_route"{
    type = string
}

variable "name_acl"{
    type = string
}

variable "name_sg"{
    type = string
}

variable "name_escalonamento"{
    type = string
}

variable "maximo"{
    type = number
}

variable "minimo"{
    type = number
}

variable "producao"{
    type = bool
}
