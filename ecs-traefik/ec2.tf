resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                      = "${module.global_label.id}-main-autoscaling-group-ecs"
  vpc_zone_identifier       = data.terraform_remote_state.main.outputs.vpc_public_subnets
  min_size                  = var.autoscaling_min_size
  max_size                  = var.autoscaling_max_size
  desired_capacity          = var.autoscaling_desired_capacity
  launch_configuration      = aws_launch_configuration.ecs-lc.name
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "${module.global_label.id}-main"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "ecs" {
  name                      = "${module.global_label.id}-main-auto-scaling-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.ecs_autoscaling_group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}

resource "aws_launch_configuration" "ecs-lc" {
  name_prefix     = "${module.global_label.id}-main-launch-configuration"
  security_groups = [
    data.terraform_remote_state.main.outputs.sg_http_id,
    data.terraform_remote_state.main.outputs.sg_http_8080_id,
    data.terraform_remote_state.main.outputs.sg_https_id,
    data.terraform_remote_state.main.outputs.sg_mysql_id
  ]

  image_id                    = data.aws_ami.latest_ecs.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ecs-ec2-role.id
  user_data                   = data.template_file.ecs-cluster.rendered
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ecs ec2 role
resource "aws_iam_role" "ecs-ec2-role" {
  name = "${module.global_label.id}-main-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs-ec2-role" {
  name = "${module.global_label.id}-main-ec2-role-profile"
  role = aws_iam_role.ecs-ec2-role.name
}

resource "aws_iam_role_policy" "ecs-ec2-role-policy" {
  name = "${module.global_label.id}-main-ec2-role-policy"
  role = aws_iam_role.ecs-ec2-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        },
        {
            "Sid": "TraefikECSReadAccess",
            "Effect": "Allow",
            "Action": [
                "ecs:ListClusters",
                "ecs:DescribeClusters",
                "ecs:ListTasks",
                "ecs:DescribeTasks",
                "ecs:DescribeContainerInstances",
                "ecs:DescribeTaskDefinition",
                "ec2:DescribeInstances"
            ],
            "Resource": [
                "*"
            ]
        },


        {
            "Sid": "DevAssetsBucketListObjects",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${data.terraform_remote_state.main.outputs.assets_dev_bucket}"
            ]
        },
        {
            "Sid": "DevAssetsBucketAllObjectActions",
            "Effect": "Allow",
            "Action": [
                "s3:*Object"
            ],
            "Resource": [
                "arn:aws:s3:::${data.terraform_remote_state.main.outputs.assets_dev_bucket}/*"
            ]
        }
    ]
}
EOF
}

# ecs service role
resource "aws_iam_role" "ecs-service-role" {
  name = "${module.global_label.id}-main-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-service-attach" {
  role = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
