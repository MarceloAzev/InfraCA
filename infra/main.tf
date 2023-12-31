terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.23"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.regiao_us_aws
}