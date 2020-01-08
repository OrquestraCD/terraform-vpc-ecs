terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    encrypt = true
    bucket = "terraform-state"
    key    = "ecs-traefik/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  version                    = ">= 2.19.0"
  skip_requesting_account_id = true
  region                     = var.region
}

provider "local" {
  version = "~> 1.3"
}

provider "random" {
  version = "~> 2.1"
}

provider "null" {
  version = "~> 2.0"
}

provider "tls" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.1"
}
