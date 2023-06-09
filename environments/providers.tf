provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.environment
      Team        = var.team
      Application = var.application
    }
  }
}

terraform {
  required_version = ">1.1.0"
  backend "s3" {}

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }
}
