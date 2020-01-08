resource "aws_s3_bucket" "app_dev" {
  bucket = local.app_dev_domain
  acl    = "public-read"
  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[{
      "Sid":"PublicReadGetObject",
          "Effect":"Allow",
        "Principal": "*",
        "Action":["s3:GetObject"],
        "Resource":["arn:aws:s3:::${local.app_dev_domain}/*"]
      }]
}
EOF

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET","HEAD"]
    allowed_origins = ["https://${local.app_dev_domain}","https://${local.api_dev_domain}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = "S3 Serverless Framework"
    Build       = "Terraform"
    Enterprise  = upper(var.label_name)
    Environment = "Development"
  }
}

resource "aws_s3_bucket" "assets_dev" {
  bucket = local.assets_dev_bucket
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET","HEAD","PUT","POST","DELETE"]
    allowed_origins = ["https://${local.app_dev_domain}","https://${local.api_dev_domain}", "*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = "S3 Serverless Framework"
    Build       = "Terraform"
    Enterprise  = upper(var.label_name)
    Environment = "Development"
  }
}
