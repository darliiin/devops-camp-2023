#   ┌─────────────────────┐
#   │ sg for instance      │
#   └─────────────────────┘

module "wordpress_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.2"
  name    = local.labels.wordpress_sg

  description = "Security group for WordPress"
  vpc_id      = data.aws_vpc.target.id

  tags = var.tags

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-tcp"
      description              = "Open connection with rds security group"
      source_security_group_id = module.wordpress_rds_sg.security_group_id
    },
    {
      rule                     = "http-80-tcp"
      description              = "Open http connection"
      source_security_group_id = module.wordpress_alb_sg.security_group_id
    }
  ]

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      description = "Open ssh connection"
      cidr_blocks = var.office_ip
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "Open all ipv4 connection"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

#   ┌─────────────────────┐
#   │ rds sg              │
#   └─────────────────────┘

module "wordpress_rds_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.17.2"
  name        = local.labels.wordpress_rds_sg
  description = "Security group for RDS"
  vpc_id      = data.aws_vpc.target.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.wordpress_sg.security_group_id
    }
  ]

  ingress_with_cidr_blocks = [
    {
      rule        = "mysql-tcp"
      cidr_blocks = "54.148.180.72/32"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "Open all ipv4 connection"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = var.tags
}



#   ┌─────────────────────┐
#   │ alb sg              │
#   └─────────────────────┘

module "wordpress_alb_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.0.0"
  name        = local.labels.wordpress_alb_sg
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.target.id
  tags        = var.tags

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Open https connection"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Open http connection"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      description = "Open all ipv4 connection"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}




