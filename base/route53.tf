data aws_route53_zone zone {
  name = "${var.base_domain}."
}

resource "aws_route53_record" "app_dev" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.app_dev_domain
  type    = "A"

  alias {
    name                   = aws_s3_bucket.app_dev.website_domain
    zone_id                = aws_s3_bucket.app_dev.hosted_zone_id
    evaluate_target_health = true
  }
}
