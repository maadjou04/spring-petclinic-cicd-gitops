terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "petclinic-tfstate-binome-XX"  # À remplacer par votre bucket
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "petclinic-tfstate-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
