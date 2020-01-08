variable "region" {
  type        = string
  description = "Region AWS"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "This is the primary CIDR block for your VPC"
  default     = "10.10.0.0/16"
}

variable "vpc_cdir_private_subnets" {
  type    = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  description = "Ip range for the private subnet"
}

variable "vpc_cdir_public_subnets" {
  type    = list(string)
  default = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
  description = "Ip range for the public subnet"
}

variable "vpc_cdir_database_subnets" {
  type    = list(string)
  default = ["10.10.7.0/24", "10.10.8.0/24", "10.10.9.0/24"]
  description = "Ip range for the database subnet"
}

variable "label_environment" {
  type    = string
  default = "dev"
}

variable "label_name" {
  type    = string
  default = "whatever"
}

variable "base_domain" {
  type    = string
  default = "example.com"
  description = "Domain base for the application"
}

variable "instance_type" {
  default     = "t3.medium"
  description = "Instances type"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "ecr_container_name" {
  default = "backend"
}
variable "rds_database_name" {
  default = "backenddb"
}
variable "rds_username" {
  default = "administrator"
}
