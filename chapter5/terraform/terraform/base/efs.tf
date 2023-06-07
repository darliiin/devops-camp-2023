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
      subnet_id = data.aws_subnet.wordpress_subnet_a_zone.id
    }
    "us-east-2-1b" = {
      subnet_id = data.aws_subnet.wordpress_subnet_b_zone.id
    }
    "us-east-2-1c" = {
      subnet_id = data.aws_subnet.wordpress_subnet_c_zone.id
    }
  }

  security_group_name   = local.labels.wordpress_efs_sg
  security_group_vpc_id = data.aws_vpc.target.id

  security_group_rules = {
    ingress = {
      rule                     = "nfs-tcp"
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
