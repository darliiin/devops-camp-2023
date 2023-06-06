locals {
  labels = {
    wordpress_sg     = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "sg"])
    wordpress_ec2    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "ec2"])
    wordpress_rds    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "rds"])
    wordpress_rds_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "rds-sg"])
    wordpress_efs    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "efs"])
    wordpress_efs_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "efs-sg"])
    wordpress_alb_tg = join(module.wordpress_label.delimiter, [var.environment, var.client, "tg"])
    wordpress_alb_sg = join(module.wordpress_label.delimiter, [var.environment, var.client, "wp", "alb-sg"])
    wordpress_alb    = join(module.wordpress_label.delimiter, [var.environment, var.client, "wp", "alb"])
    wordpress_acm    = join(module.wordpress_label.delimiter, [var.environment, var.client, "wp.saritasa-camps.link"])
  }
  efs_id       = module.efs.id
  random_pwd   = random_password.password.result
  endpoint_rds = module.wordpress_rds.db_instance_endpoint
  db_name_rds  = module.wordpress_rds.db_instance_name

  # Authentication Unique Keys and Salts for wordpress
  random_string_array = [
    random_string.random[0].id,
    random_string.random[1].id,
    random_string.random[2].id,
    random_string.random[3].id,
    random_string.random[4].id,
    random_string.random[5].id,
    random_string.random[6].id,
    random_string.random[7].id,
  ]
}
