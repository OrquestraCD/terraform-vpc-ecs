terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    encrypt = true
    bucket = "terraform-state"
    key    = "ecs-api-backend/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  version                    = ">= 2.19.0"
  skip_requesting_account_id = true
  region                     = var.region
}

module "global_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = terraform.workspace
  environment = var.environment
  name        = var.label_name
  delimiter   = "-"

  tags = {
    "Build"      = "Terraform"
    "Enterprise" = var.label_name
    "Module"     = "api-backend-laravel"
    "Workspace"  = terraform.workspace
  }
}
