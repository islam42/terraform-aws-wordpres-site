# provider section

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.0"
    }
  }

  backend "s3" {}

  # backend "s3" {
  #   bucket = "athena-alb-results-ezo"
  #   key    = "terraform.tfstate"
  #   region = "us-east-1"
  #   dynamodb_table = "terraform-state"
  #   encrypt = true
  # }
}

provider "aws" {
  region = var.region
}