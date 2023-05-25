/* 
  ┌──────────────────────────────────────┐
  │ env=specific configuration variables │
  └──────────────────────────────────────┘
 */

environment = "dev"


/* 
  ┌──────────────────────────────────────┐
  │ wordpress configuration variables    │
  └──────────────────────────────────────┘
 */

cache_vpc_tags = {
  Name = "default"
}

cache_availability_zones = ["us-east-2a", "us-east-2b"]
cache_engine             = "wordpress"

ingress_rule_ec2_sg = [
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Open http connection"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Open https connection"
    cidr_blocks = "0.0.0.0/0"
  },
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Open ssh connection"
    cidr_blocks = "0.0.0.0/0"
  }
]


egress_rule_ec2_sg = [
  {
    rule        = "all-all"
    description = "Open all ipv4 connection"
    cidr_blocks = "0.0.0.0/0"
  }
]


/*
  ┌────────────────────────────────┐
  │ rds sg                         │
  └────────────────────────────────┘
*/

ingress_rule_rds_sg = [
  {
    cidr_blocks = "195.201.120.196/32"
    rule        = "mysql-tcp"
  }
]

egress_rule_rds_sg = [
  {
    rule        = "all-all"
    description = "Open all ipv4 connection"
    cidr_blocks = "0.0.0.0/0"
  }
]


/*
  ┌────────────────────────────────┐
  │ alb sg                         │
  └────────────────────────────────┘
 */

ingress_rule_alb_sg = [
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

egress_rule_alb_sg = [
  {
    rule        = "all-all"
    description = "Open all ipv4 connection"
    cidr_blocks = "0.0.0.0/0"
  }
]
