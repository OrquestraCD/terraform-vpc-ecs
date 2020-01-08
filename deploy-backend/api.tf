locals {
  api_task_container      = "api-${var.environment}"
  api_svc            = "${local.api_task_container}-svc"
  api_log_group_path = "/${var.ecs_name}/${local.api_task_container}"
  api_traefik_frontend_host = "api${var.environment=="prod"?"":"-${var.environment}"}.${var.base_domain}"
}

resource "aws_cloudwatch_log_group" "api" {
  name = local.api_log_group_path
}

module "api-task-definition" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.21.0"
  container_image = "${data.terraform_remote_state.main.outputs.api_repository}:${var.environment}-${var.tag}"
  container_name = local.api_task_container

  port_mappings = [
    {
      hostPort      = 0
      containerPort = 8080
      protocol      = "tcp"
    }
  ]

  docker_labels = {
    "traefik.frontend.rule" = "Host:${local.api_traefik_frontend_host}",
    "traefik.frontend.headers.customResponseHeaders" = "Access-Control-Allow-Origin:*",
    "traefik.enable"        = "true",
    "traefik.protocol"      = "http"
  }

  environment = [
    {
      name: "APP_ENV"
      value: var.environment
    },{
      name: "ASSETS_BUCKET"
      value: data.aws_ssm_parameter.assets_bucket.value
    },{
      name: "AWS_S3_REGION"
      value: var.region
    }
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region" = data.aws_region.current.id
      "awslogs-group"  = aws_cloudwatch_log_group.api.name
      "awslogs-stream-prefix" = local.api_task_container
    }
    secretOptions = []
  }

  container_cpu = "250"
  container_memory = "512"
  container_memory_reservation = "512"
}

resource "aws_ecs_task_definition" "api" {
  family = local.api_task_container
  container_definitions = module.api-task-definition.json
}

resource "aws_ecs_service" "api-svc" {
  name            = local.api_svc
  cluster         = data.terraform_remote_state.ecs_traefik.outputs.ecs_id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 50
}
