data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "terraform_remote_state" "main" {
  backend = "s3"

  config = {
    bucket  = "terraform-state"
    key     = "base/terraform.tfstate"
    region  = "us-east-1"
  }
}

# Get the latest ECS AMI
data "aws_ami" "latest_ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"] # AWS
}

# User data for ECS cluster
data "template_file" "ecs-cluster" {
  template = <<EOF
#!/bin/bash
echo ECS_CLUSTER=$${ecs_cluster} >> /etc/ecs/ecs.config
EOF
  vars = {
    ecs_cluster = aws_ecs_cluster.default.name
  }
}
