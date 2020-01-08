resource "aws_alb" "default" {
  name            = "${module.global_label.id}-ecs-alb"
  subnets         = module.vpc.public_subnets
  security_groups = [module.http_security_group.this_security_group_id,module.https_security_group.this_security_group_id]
  enable_http2    = "true"
  idle_timeout    = 600
}
