module "global_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = terraform.workspace
  environment = var.label_environment
  name        = var.label_name
  delimiter   = "-"

  tags = {
    "Build"      = "Terraform"
    "Enterprise" = upper(var.label_name)
    "Module"     = "base"
    "Workspace"  = terraform.workspace
  }
}

module "vpc" {
  version             = "2.15.0"
  source              = "terraform-aws-modules/vpc/aws"
  name                = "${module.global_label.id}-vpc"
  cidr                = var.vpc_cidr
  azs                 = data.aws_availability_zones.available.names
  private_subnets     = var.vpc_cdir_private_subnets
  public_subnets      = var.vpc_cdir_public_subnets
  database_subnets    = var.vpc_cdir_database_subnets

  # DNS
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  tags = module.global_label.tags
}

module "ssh_security_group" {
  source                = "terraform-aws-modules/security-group/aws//modules/ssh"
  version               = "~> 3.0"
  name                  = "${module.global_label.id}-ec2-ssh-sg"
  vpc_id                = module.vpc.vpc_id
  ingress_cidr_blocks   = ["0.0.0.0/0"]
}

module "mysql_security_group" {
  source                = "terraform-aws-modules/security-group/aws//modules/mysql"
  version               = "~> 3.0"
  name                  = "${module.global_label.id}-ec2-msyql-sg"
  vpc_id                = module.vpc.vpc_id
  ingress_cidr_blocks   = ["0.0.0.0/0"]
}

module "http_security_group" {
  source                = "terraform-aws-modules/security-group/aws//modules/http-80"
  version               = "~> 3.0"
  name                  = "${module.global_label.id}-http-sg"
  vpc_id                = module.vpc.vpc_id
  ingress_cidr_blocks   = ["0.0.0.0/0"]
}

module "https_security_group" {
  source                = "terraform-aws-modules/security-group/aws//modules/https-443"
  version               = "~> 3.0"
  name                  = "${module.global_label.id}-https-sg"
  vpc_id                = module.vpc.vpc_id
  ingress_cidr_blocks   = ["0.0.0.0/0"]
}

module "http_security_group_8080" {
  source                = "terraform-aws-modules/security-group/aws//modules/http-8080"
  version               = "~> 3.0"
  name                  = "${module.global_label.id}-http-sg"
  vpc_id                = module.vpc.vpc_id
  ingress_cidr_blocks   = ["0.0.0.0/0"]
}
