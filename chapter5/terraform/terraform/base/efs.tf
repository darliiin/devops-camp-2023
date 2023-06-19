#   ┌─────────────────────┐
#   │ efs                 │
#   └─────────────────────┘

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.1.1"
  name    = local.labels.wordpress_efs

  mount_targets = {
    for subnet in values(data.aws_subnet.wordpress_subnets) :
    subnet.availability_zone => {
      subnet_id = subnet.id
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
