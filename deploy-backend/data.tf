data "aws_region" "current" {}

data "terraform_remote_state" "main" {
  backend = "s3"

  config = {
    bucket  = "terraform-state"
    key     = "base/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "terraform_remote_state" "ecs_traefik" {
  backend = "s3"

  config = {
    bucket  = "terraform-state"
    key     = "ecs-traefik/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "aws_ssm_parameter" "db_database" {
  name = "${local.ssm_name_base}/db_database"
}

data "aws_ssm_parameter" "api_domain" {
  name = "${local.ssm_name_base}/api_domain"
}

data "aws_ssm_parameter" "assets_bucket" {
  name = "${local.ssm_name_base}/assets_bucket"
}
