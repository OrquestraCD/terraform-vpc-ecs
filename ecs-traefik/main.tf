module "global_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = "ecs"
  environment = var.label_environment
  name        = var.label_name
  delimiter   = "-"

  tags = {
    "Build"      = "Terraform"
    "Enterprise" = var.label_name
    "Module"     = "ecs-traefik"
    "Workspace"  = terraform.workspace
  }
}

# ECS cluster
resource "aws_ecs_cluster" "default" {
  name = "${module.global_label.id}-main"
}

resource "aws_ssm_parameter" "ecs_id" {
  name = "${local.ssm_name_base}/ecs_id"
  type = "String"
  value = aws_ecs_cluster.default.id
}
