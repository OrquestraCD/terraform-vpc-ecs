variable "region" {
  type        = string
  description = "Region AWS"
  default     = "us-east-1"
}

variable "environment" {
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

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "ecs_name" {
  type    = string
  default = "main"
}

variable "tag" {
  default = "latest"
}
