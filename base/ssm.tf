module "dev_ssm" {
  source          = "../modules/ssm_writer"
  parameter_write = [
    {
      name            = "${local.ssm_dev_base}/app_dev_bucket_name"
      value           = aws_s3_bucket.app_dev.id
      type            = "String"
      overwrite       = "true"
      description     = "Develop application bucket name"
    },
    {
      name            = "${local.ssm_dev_base}/db_database"
      value           = "dev_backend"
      type            = "String"
      overwrite       = "true"
      description     = "Develop database name"
    },
    {
      name            = "${local.ssm_dev_base}/api_domain"
      value           = local.api_dev_domain
      type            = "String"
      overwrite       = "true"
      description     = "Backend domain name"
    },
    {
      name            = "${local.ssm_dev_base}/assets_bucket"
      value           = aws_s3_bucket.assets_dev.id
      type            = "String"
      overwrite       = "true"
      description     = "Develop assets bucket name"
    }
  ]
}
