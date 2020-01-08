locals {
  ssm_name_base    = "/global/${module.global_label.environment}/${module.global_label.name}"
  log_group_path   = "/${var.label_name}/${var.ecr_container_name}"
  ssm_dev_base     = "/global/dev/${module.global_label.name}"
  app_dev_domain   = "app-dev.${var.base_domain}"
  api_dev_domain   = "api-dev.${var.base_domain}"
  assets_dev_bucket = "${var.label_name}-dev-assets"
}
