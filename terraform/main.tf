terraform {
    required_providers {
        aws = {
            version = "~> 5.9.0"
            source  = "hashicorp/aws"
        }
    }
}

provider "aws" {
    profile = "default"
    region = "eu-south-1"
}

