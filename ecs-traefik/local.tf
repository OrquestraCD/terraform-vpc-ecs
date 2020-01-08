locals {
  traefik_log_group_path = "/${var.label_name}/${var.traekik_default_name}"
  traefik_service_name   = "${var.traekik_default_name}-svc"
  ssm_name_base          = "/global/${module.global_label.environment}/${module.global_label.name}"
}
