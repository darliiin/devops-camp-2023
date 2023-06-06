#   ┌─────────────────────┐
#   │ random pass for rds │
#   └─────────────────────┘

resource "random_password" "password" {
  length           = 12
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}



#   ┌─────────────────────┐
#   │ rds                 │
#   └─────────────────────┘

module "wordpress_rds" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = local.labels.wordpress_rds

  # DB parameter group
  family         = var.family_rds
  version        = "5.9.0"
  engine         = var.engine_rds
  instance_class = var.instance_class_rds

  allocated_storage = var.allocated_storage_rds

  # DB option group
  major_engine_version = var.major_engine_version_rds

  db_name  = var.db_name
  username = var.db_username
  port     = var.db_port

  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [module.wordpress_rds_sg.security_group_id]

  maintenance_window = var.maintenance_window_rds
  backup_window      = var.backup_window_rds
  tags               = var.tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.wordpress.ids
  create_random_password = false
  password               = random_password.password.result

}

