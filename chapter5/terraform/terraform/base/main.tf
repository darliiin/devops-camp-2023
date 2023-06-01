module "wordpress_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  name        = var.client
  environment = var.environment
  attributes  = [var.project, var.cache_engine]
}

module "wordpress_instance_labels" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  for_each   = toset(var.cache_availability_zones)
  context    = module.wordpress_label.context
  attributes = [var.project, var.cache_engine, each.value]
}

locals {
  labels = {
    wordpress_sg     = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "sg"])
    wordpress_ec2    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "ec2"])
    wordpress_rds_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "rds-sg"])
    wordpress_efs    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "efs"])
    wordpress_efs_sg = join(module.wordpress_label.delimiter, [module.wordpress_label.id, "efs-sg"])
    wordpress_alb_sg = join(module.wordpress_label.delimiter, [var.environment, var.client, "wp", "alb-sg"])
    wordpress_alb    = join(module.wordpress_label.delimiter, [var.environment, var.client, "wp", "alb"])
    wordpress_acm    = join(module.wordpress_label.delimiter, [var.environment, var.client, "wp.saritasa-camps.link"])

  }
  efs_id       = module.efs.id
  random_pswd  = random_password.password.result
  endpoint_rds = module.wordpress_rds.db_instance_endpoint
  db_name_rds  = module.wordpress_rds.db_instance_name
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


#   ┌─────────────────────┐
#   │ random pass for rds │
#   └─────────────────────┘

resource "random_password" "password" {
  length           = 12
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}


#   ┌──────────────────────────────────────┐
#   │ random string for wp-config.php      │
#   └──────────────────────────────────────┘

resource "random_string" "random" {
  count            = 8
  length           = 64
  special          = true
  override_special = "_-!%^&*()[]{}<>"
}

#   ┌─────────────────────┐
#   │ sg for instans      │
#   └─────────────────────┘

module "wordpress_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.2"
  name    = local.labels.wordpress_sg

  description             = "Security group for WordPress"
  vpc_id                  = data.aws_vpc.target.id
  egress_with_cidr_blocks = var.egress_rule_ec2_sg

  tags = var.tags

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-tcp"
      description              = "Open connection with rds security group"
      source_security_group_id = module.wordpress_rds_sg.security_group_id
    },
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Open http connection"
      source_security_group_id = module.wordpress_alb_sg.security_group_id
    }
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Open ssh connection"
      cidr_blocks = "54.148.180.72/32"
    }
  ]
}

#   ┌─────────────────────┐
#   │ key                 │
#   └─────────────────────┘


module "ssh_key_pair" {
  source                = "cloudposse/key-pair/aws"
  stage                 = var.environment
  name                  = var.client
  ssh_public_key_path   = "${path.cwd}/assets/private_keys"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}


#   ┌─────────────────────┐
#   │ instans             │
#   └─────────────────────┘

module "ec2_instance" {

  for_each = toset(var.instance_names)
  source   = "terraform-aws-modules/ec2-instance/aws"
  name     = "${local.labels.wordpress_ec2}-${each.value}"

  ami                    = "ami-08333bccc35d71140"
  instance_type          = "t3.micro"
  key_name               = module.ssh_key_pair.key_name
  vpc_security_group_ids = [module.wordpress_sg.security_group_id]
  subnet_id              = "subnet-06bf7d626cfb50b30"

  tags = var.tags

  user_data = templatefile("${path.cwd}/terraform/base/userd.tpl", {
    random_pswd         = local.random_pswd,
    endpoint_rds        = local.endpoint_rds,
    db_name_rds         = local.db_name_rds,
    random_string_array = local.random_string_array
    efs_id              = local.efs_id

  })

}

#   ┌─────────────────────┐
#   │ rds sg              │
#   └─────────────────────┘

module "wordpress_rds_sg" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "4.17.2"
  name                     = local.labels.wordpress_rds_sg
  description              = "Security group for RDS"
  vpc_id                   = data.aws_vpc.target.id
  ingress_with_cidr_blocks = var.ingress_rule_rds_sg
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.wordpress_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = var.egress_rule_rds_sg
  tags                    = var.tags
}


#   ┌─────────────────────┐
#   │ rds                 │
#   └─────────────────────┘

# pass


module "wordpress_rds" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "${var.environment}-${var.client}-rds"

  # DB parameter group
  family         = "mysql8.0"
  version        = "5.9.0"
  engine         = "mysql"
  instance_class = "db.t4g.micro"

  allocated_storage = 20

  # DB option group
  major_engine_version = "8.0"

  db_name  = var.db_name
  username = var.username
  port     = var.port

  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [module.wordpress_rds_sg.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  tags               = var.tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.wordpress.ids
  create_random_password = false
  password               = random_password.password.result

}

#   ┌─────────────────────┐
#   │ efs                 │
#   └─────────────────────┘

module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name = local.labels.wordpress_efs
  tags = var.tags

  # Mount targets / security group
  mount_targets = {
    "us-east-2-1a" = {
      subnet_id = "subnet-06bf7d626cfb50b30"
    }
    "us-east-2-1b" = {
      subnet_id = "subnet-0412d6a553a654a0a"
    }
    "us-east-2-1c" = {
      subnet_id = "subnet-0c437405f83328b86"
    }
  }

  security_group_name   = local.labels.wordpress_efs_sg
  security_group_vpc_id = data.aws_vpc.target.id

  security_group_rules = {
    ingress = {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      description              = "Open NFS"
      source_security_group_id = module.wordpress_sg.security_group_id
    },
    outbound = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }

  attach_policy = false
}


#   ┌─────────────────────┐
#   │ alb sg              │
#   └─────────────────────┘

module "wordpress_alb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  #   version                  = "4.17.2"
  name                     = local.labels.wordpress_alb_sg
  description              = "Security group for ALB"
  vpc_id                   = data.aws_vpc.target.id
  ingress_with_cidr_blocks = var.ingress_rule_alb_sg
  egress_with_cidr_blocks  = var.egress_rule_alb_sg
  tags                     = var.tags
}


#   ┌─────────────────────┐
#   │ alb                 │
#   └─────────────────────┘

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  name   = local.labels.wordpress_alb

  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.target.id
  subnets         = data.aws_subnets.wordpress.ids
  security_groups = [module.wordpress_alb_sg.security_group_id, "sg-0d10a167dff95ae61"]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        my_target = {
          target_id = data.aws_instance.ec2-1.id
          port      = 80
        }
        my_other_target = {
          target_id = data.aws_instance.ec2-2.id
          port      = 80
        }
      }
    }
  ]

  tags = var.tags

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = aws_acm_certificate_validation.certificate.certificate_arn
      target_group_index = 0
    }
  ]
  depends_on = [data.aws_instance.ec2-1, data.aws_instance.ec2-2]
}

#   ┌─────────────────────┐
#   │ acm certificate     │
#   └─────────────────────┘

resource "aws_acm_certificate" "cert" {
  domain_name       = local.labels.wordpress_acm
  validation_method = "DNS"

}

data "aws_route53_zone" "zone_record" {
  name         = "saritasa-camps.link"
  private_zone = false

}

resource "aws_route53_record" "record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone_record.zone_id

}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]

}

resource "aws_route53_record" "Aroute53" {
  zone_id = data.aws_route53_zone.zone_record.zone_id
  name    = aws_acm_certificate.cert.domain_name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}



