#   ┌─────────────────────┐
#   │ sg for instance     │
#   └─────────────────────┘

module "wordpress_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.0"
  name        = local.labels.wordpress_sg
  description = "Security group for WordPress"
  vpc_id      = data.aws_vpc.target.id

  ingress_with_source_security_group_id = [
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
      cidr_blocks = join(",", var.allowed_ssh_ips)
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
  version     = "5.1.0"
  name        = local.labels.wordpress_rds_sg
  description = "Security group for RDS"
  vpc_id      = data.aws_vpc.target.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      description              = "Allow inbound traffic from ec2 security group"
      source_security_group_id = module.wordpress_sg.security_group_id
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule                     = "all-all"
      description              = "Open all ipv4 connection"
      source_security_group_id = module.wordpress_sg.security_group_id
    }
  ]
}

#   ┌─────────────────────┐
#   │ alb sg              │
#   └─────────────────────┘

module "wordpress_alb_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "5.1.0"
  name        = local.labels.wordpress_alb_sg
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.target.id
  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      description = "Open https connection"
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
