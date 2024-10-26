
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  alias  = "virginia"
  default_tags {
    tags = {
      Environment = "Laboratory"
      Owner       = "leomarqz"
      IaC         = "Terraform"
    }
  }
}