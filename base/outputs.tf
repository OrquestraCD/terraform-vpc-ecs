output "vpc_id" {
  value = module.vpc.vpc_id
}

output "db_pwd" {
  value = random_string.password_generator.result
}

output "db_host" {
  value = module.mysql.this_db_instance_address
}

output "db_username" {
  value = module.mysql.this_db_instance_username
}

output "db_database" {
  value = module.mysql.this_db_instance_name
}

output "api_repository" {
  value = module.ecr_backend.registry_url
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "alb_id" {
  value = aws_alb.default.id
}

output "alb_dns_name" {
  value = aws_alb.default.dns_name
}

output "alb_zone_id" {
  value = aws_alb.default.zone_id
}

output "sg_ssh_id" {
  value = module.ssh_security_group.this_security_group_id
}

output "sg_http_id" {
  value = module.http_security_group.this_security_group_id
}

output "sg_http_8080_id" {
  value = module.http_security_group_8080.this_security_group_id
}

output "sg_https_id" {
  value = module.https_security_group.this_security_group_id
}

output "sg_mysql_id" {
  value = module.mysql_security_group.this_security_group_id
}

output "domain_zone_id" {
  value = data.aws_route53_zone.zone.id
}

output "assets_dev_bucket" {
  value = aws_s3_bucket.assets_dev.id
}
