# provider section

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.0"
    }
  }
  cloud {
    organization = "arcloudops"
    workspaces {
      name = "development"
    }
  }
}

provider "aws" {
  region = var.region
}