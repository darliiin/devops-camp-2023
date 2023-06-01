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

egress_rule_ec2_sg = [
  {
    rule        = "all-all"
    description = "Open all ipv4 connection"
    cidr_blocks = "0.0.0.0/0"
  }
]



/*
  ┌────────────────────────────────┐
  │ rds                            │
  └────────────────────────────────┘
*/

db_name  = "dev_daria_nalimova_user_rds"
username = "admin"
port     = "3306"

/*
  ┌────────────────────────────────┐
  │ rds sg                         │
  └────────────────────────────────┘
*/

ingress_rule_rds_sg = [
  {
    rule        = "mysql-tcp"
    cidr_blocks = "54.148.180.72/32"
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
