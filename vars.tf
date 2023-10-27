variable "amis"{
    type = map
    
    default = {
        "us-east-1" = "ami-0fc5d935ebf8bc3bc" #ubuntu linux
        "us-east-2" = "ami-0e83be366243f524a"
    }
}

variable "key-name"{
    default = "iac-estudo"
}

variable "cdirs_acesso_remoto"{
    type = list
    default = ["179.83.80.34/32"]

}