terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
   backend "s3" {
     bucket  = "ecs-blog-app-cluster"
     key     = "ecs-blog/cluster/terraform.tfstate"
     region  = "ap-south-1"
     encrypt = true
   }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

# Reads ACM cert ARN from persistent layer — no manual secrets needed
data "terraform_remote_state" "persistent" {
  backend = "s3"
  config = {
    bucket = "ecs-blog-app"
    key    = "ecs-blog/persistent/terraform.tfstate"
    region = "ap-south-1"
  }
}