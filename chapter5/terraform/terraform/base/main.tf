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
    wordpress_alb_sg = join(module.wordpress_label.delimiter, ["dev-daria-nalimova-user-wp", "alb-sg"])
    wordpress_alb    = join(module.wordpress_label.delimiter, ["dev-daria-nalimova-user-wp", "alb"])
    wordpress_acm    = join(module.wordpress_label.delimiter, [module.wordpress_label.id, ".saritasa-camps.link"])
  }
}

#   ┌─────────────────────┐
#   │ sg for instans      │
#   └─────────────────────┘


module "wordpress_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.2"
  name    = local.labels.wordpress_sg

  description              = "Security group for WordPress"
  vpc_id                   = data.aws_vpc.target.id
  ingress_with_cidr_blocks = var.ingress_rule_ec2_sg
  egress_with_cidr_blocks  = var.egress_rule_ec2_sg

  tags = var.tags
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

  user_data = <<EOF
#!/bin/bash
mkdir /tmp/ssm
curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm -o /tmp/ssm/amazon-ssm-agent.rpm
sudo yum install -y /tmp/ssm/amazon-ssm-agent.rpm
sudo stop amazon-ssm-agent
sudo -E amazon-ssm-agent -register -code "activation-code" -id "activation-id" -region "us-east-2"
sudo start amazon-ssm-agent
sudo yum -y install nginx
systemctl start nginx
systemctl enable nginx
  EOF
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
  egress_with_cidr_blocks  = var.egress_rule_rds_sg
  tags                     = var.tags

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.wordpress_sg.security_group_id
    }
  ]
}


#   ┌─────────────────────┐
#   │ rds                 │
#   └─────────────────────┘

module "wordpress_rds" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "dev-daria-nalimova-user-rds"
  #   instance_use_identifier_prefix  = false
  #   monitoring_role_use_name_prefix = false
  #   skip_final_snapshot = true


  # DB parameter group
  family            = "mysql8.0"
  version           = "5.9.0"
  engine            = "mysql"
  instance_class    = "db.t4g.micro"
  allocated_storage = 20

  # DB option group
  major_engine_version = "8.0"

  db_name  = "dev_daria_nalimova_user_rds"
  username = "admin"
  port     = "3306"

  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [module.wordpress_sg.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  tags               = var.tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = data.aws_subnets.wordpress.ids

}

resource "random_password" "password" {
  length  = 8
  special = true
}

resource "aws_db_instance" "wordpress_rds" {
  instance_class    = "db.t4g.micro"
  allocated_storage = 20
  engine            = "mysql"
  username          = "admin"
  password          = random_password.password.result
}

#
# #   ┌─────────────────────┐
# #   │ efs sg              │
# #   └─────────────────────┘
#
# # module "wordpress_efs_sg" {
# #   source                   = "terraform-aws-modules/security-group/aws"
# #
# # }
#
# #   ┌─────────────────────┐
# #   │ efs                 │
# #   └─────────────────────┘
#
# module "efs" {
#   source = "terraform-aws-modules/efs/aws"
#
#   # File system
#   name = local.labels.wordpress_efs
#   tags = var.tags
#
#   # Mount targets / security group
#   mount_targets = {
#     "us-east-2-1a" = {
#       subnet_id = "subnet-06bf7d626cfb50b30"
#     }
#     "us-east-2-1b" = {
#       subnet_id = "subnet-0412d6a553a654a0a"
#     }
#     "us-east-2-1c" = {
#       subnet_id = "subnet-0c437405f83328b86"
#     }
#   }
#
#   security_group_name   = local.labels.wordpress_efs_sg
#   security_group_vpc_id = data.aws_vpc.target.id
#
#   security_group_rules = {
#     ingress = {
#       from_port                = 2049
#       to_port                  = 2049
#       protocol                 = "tcp"
#       description              = "Open NFS"
#       source_security_group_id = module.wordpress_sg.security_group_id
#     },
#     outbound = {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#       description = "Allow all outbound traffic"
#     }
#   }
# }
#
#
# #   ┌─────────────────────┐
# #   │ alb sg              │
# #   └─────────────────────┘
#
# module "wordpress_alb_sg" {
#   source = "terraform-aws-modules/security-group/aws"
#   #   version                  = "4.17.2"
#   name                     = local.labels.wordpress_alb_sg
#   description              = "Security group for ALB"
#   vpc_id                   = data.aws_vpc.target.id
#   ingress_with_cidr_blocks = var.ingress_rule_alb_sg
#   egress_with_cidr_blocks  = var.egress_rule_alb_sg
#   tags                     = var.tags
# }
#
#
# #   ┌─────────────────────┐
# #   │ alb                 │
# #   └─────────────────────┘
#
# module "alb" {
#   source = "terraform-aws-modules/alb/aws"
#   name   = local.labels.wordpress_alb
#
#   load_balancer_type = "application"
#
#   vpc_id  = data.aws_vpc.target.id
#   subnets = ["subnet-0412d6a553a654a0a", "subnet-0c437405f83328b86", "subnet-06bf7d626cfb50b30"]
#   #   security_groups = [module.wordpress_alb_sg.security_group_id, "sg-0d10a167dff95ae61"]
#
#   access_logs = {
#     bucket = "my-alb-logs"
#   }
#
#   target_groups = [
#     {
#       #       name_prefix      = "pref-"
#       backend_protocol = "HTTP"
#       backend_port     = 80
#       target_type      = "instance"
#       targets = {
#         my_target = {
#           target_id = data.aws_instances.wordpress.ids[0]
#           port      = 80
#         }
#         my_other_target = {
#           target_id = data.aws_instances.wordpress.ids[1]
#           port      = 80
#         }
#       }
#     }
#   ]
#
#   tags = var.tags
#
#   #   https_listeners = [
#   #     {
#   #       port               = 443
#   #       protocol           = "HTTPS"
#   #       certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
#   #       target_group_index = 0
#   #     }
#   #   ]
#
#   #   http_tcp_listeners = [
#   #     {
#   #       port               = 80
#   #       protocol           = "HTTP"
#   #       target_group_index = 0
#   #     }
#   #   ]
#
# }


# #   ┌─────────────────────┐
# #   │ acm certificate     │
# #   └─────────────────────┘
#
# resource "aws_acm_certificate" "cert" {
#   domain_name       = local.labels.wordpress_acm
#   validation_method = "DNS"
#   tags              = var.tags
# }
#
# data "aws_route53_zone" "route53" {
#   name         = "saritasa-camps.link"
#   private_zone = false
# }
#
# resource "aws_route53_record" "record" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
#
#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.route53.zone_id
# }
#
# resource "aws_acm_certificate_validation" "cert_valid" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.record : record.fqdn]
# }
