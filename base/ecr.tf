module "ecr_backend" {
  source                          = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=tags/0.7.0"
  name                            = var.ecr_container_name
  namespace                       = terraform.workspace
  stage                           = var.label_environment
  use_fullname                    = "false"
}
