
resource "aws_route53_record" "api_dev" {
  zone_id = data.terraform_remote_state.main.outputs.domain_zone_id
  name    = data.aws_ssm_parameter.api_domain.value
  type    = "A"

  alias {
    name                   = data.terraform_remote_state.main.outputs.alb_dns_name
    zone_id                = data.terraform_remote_state.main.outputs.alb_zone_id
    evaluate_target_health = true
  }
}
