#   ┌─────────────────────┐
#   │ random pass for rds │
#   └─────────────────────┘

resource "random_password" "db_password" {
  length           = 12
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

#   ┌─────────────────────┐
#   │ rds                 │
#   └─────────────────────┘

module "wordpress_rds" {
  source                              = "terraform-aws-modules/rds/aws"
  version                             = "5.9.0"
  identifier                          = local.labels.wordpress_rds
  family                              = var.db_family
  engine                              = var.db_engine
  instance_class                      = var.db_instance_class
  allocated_storage                   = var.db_allocated_storage
  major_engine_version                = var.db_major_engine_version
  db_name                             = var.db_name
  username                            = var.db_username
  port                                = var.db_port
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [module.wordpress_rds_sg.security_group_id]
  maintenance_window                  = var.db_maintenance_window
  backup_window                       = var.db_backup_window
  tags                                = var.tags
  create_db_subnet_group              = true
  subnet_ids                          = data.aws_subnets.wordpress.ids
  create_random_password              = false
  password                            = random_password.db_password.result
}
