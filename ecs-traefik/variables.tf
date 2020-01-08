variable "region" {
  type        = string
  description = "Region AWS"
  default     = "us-east-1"
}

variable "label_environment" {
  type    = string
  default = "dev"
}

variable "label_name" {
  type    = string
  default = "whatever"
}

variable "autoscaling_min_size" {
  default = 1
}

variable "autoscaling_max_size" {
  default = 2
}

variable "autoscaling_desired_capacity" {
  default = 1
}

variable "instance_type" {
  default     = "t3.small"
  description = "Instances type"
}

variable "traekik_default_name" {
  default = "traefik"
}

variable "traefik_domain" {
  default = "example.com"
}
