/* 
  ┌──────────────────────────────────────┐
  │ env=specific configuration variables │
  └──────────────────────────────────────┘
*/

environment = "dev"


/*
  ┌────────────┐
  │ office ip  │
  └────────────┘
*/

office_ip = "54.148.180.72/32"


/*
  ┌──────────────┐
  │ unstances    │
  └──────────────┘
*/
wordpress_instances_count = 2

instance_ami  = "ami-08333bccc35d71140"
instance_type = "t3.micro"

/* 
  ┌──────────────────────────────────────┐
  │ wordpress configuration variables    │
  └──────────────────────────────────────┘
*/

vpc_tags = {
  Name = "default"
}

availability_zones = ["us-east-2a", "us-east-2b"]
engine             = "wordpress"


/*
  ┌────────────────────────────────┐
  │ rds                            │
  └────────────────────────────────┘
*/

family_rds               = "mysql8.0"
engine_rds               = "mysql"
instance_class_rds       = "db.t4g.micro"
allocated_storage_rds    = 20
major_engine_version_rds = "8.0"

maintenance_window_rds = "Mon:00:00-Mon:03:00"
backup_window_rds      = "03:00-06:00"


db_name     = "dev_daria_nalimova_user_rds"
db_username = "admin"
db_port     = "3306"

