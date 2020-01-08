resource "aws_alb_listener" "front_end" {
  load_balancer_arn = data.terraform_remote_state.main.outputs.alb_id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.traefik_svc_target_group.id
    type             = "forward"
  }
}

resource "aws_alb_target_group" "traefik_svc_target_group" {
  name       = "${local.traefik_service_name}-target-group"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = data.terraform_remote_state.main.outputs.vpc_id

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    port                = "8080"
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_ecs_service" "traefik-svc" {
  name            = local.traefik_service_name
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.traefik.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 50

  load_balancer {
    target_group_arn = aws_alb_target_group.traefik_svc_target_group.id
    container_name   = var.traekik_default_name
    container_port   = "80"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_cloudwatch_log_group" "traefik" {
  name = local.traefik_log_group_path
}

module "traefik-definition" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.21.0"
  container_image = "traefik:1.7"
  container_name = var.traekik_default_name
  port_mappings = [
    {
      hostPort      = 80
      containerPort = 80
      protocol      = "tcp"
    },
    {
      hostPort      = 8080
      containerPort = 8080
      protocol      = "tcp"
    }
  ]
  command = [
    "--api",
    "--ping",
    "--ecs",
    "--ecs.clusters=${aws_ecs_cluster.default.name}",
    "--ecs.region=${data.aws_region.current.id}",
    "--ecs.domain=${var.traefik_domain}"
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region" = data.aws_region.current.id
      "awslogs-group"  = aws_cloudwatch_log_group.traefik.name
      "awslogs-stream-prefix" = var.traekik_default_name
    }
    secretOptions = []
  }

  container_cpu = "256"
  container_memory = "256"
  container_memory_reservation = "256"
}

resource "aws_ecs_task_definition" "traefik" {
  family = var.traekik_default_name
  container_definitions = module.traefik-definition.json
}
