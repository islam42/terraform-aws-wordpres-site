# provider section

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.region
}