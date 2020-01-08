resource "random_string" "password_generator" {
  length            = 25
  special           = false
}

module "mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"
  identifier = "${module.global_label.id}-db"
  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine            = "mysql"
  engine_version    = "5.7.26"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_encrypted = false
  name     = var.rds_database_name
  username = var.rds_username
  password = random_string.password_generator.result
  port     = "3306"
  vpc_security_group_ids = [module.mysql_security_group.this_security_group_id]
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-05:00"
  multi_az = false
  # disable backups to create DB faster
  backup_retention_period = 2
  tags = module.global_label.tags
  enabled_cloudwatch_logs_exports = ["audit", "general"]
  # DB subnet group
  subnet_ids = module.vpc.public_subnets
  # DB parameter group
  family = "mysql5.7"
  # DB option group
  major_engine_version = "5.7"

  final_snapshot_identifier = "${module.global_label.id}-final"
  # todo: change this for prod
  deletion_protection = false
  publicly_accessible = "true"
  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "30"
        },
      ]
    },
  ]
}
