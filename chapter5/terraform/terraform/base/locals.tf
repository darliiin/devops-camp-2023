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
}
