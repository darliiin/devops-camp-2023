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

/*
link AMI: https://us-east-2.console.aws.amazon.com/ec2/home?region=us-east-2#ImageDetails:imageId=ami-08333bccc35d71140
AMI name: al2023-ami-2023.0.20230503.0-kernel-6.1-x86_64
*/

wordpress_instances_ami  = "ami-08333bccc35d71140"
wordpress_instances_type = "t3.micro"

/* 
  ┌──────────────────────────────────────┐
  │ wordpress configuration variables    │
  └──────────────────────────────────────┘
*/

vpc_tags = {
  Name = "default"
}

wordpress_availability_zones = ["us-east-2a", "us-east-2b"]

/*
  ┌────────────────────────────────┐
  │ wp-config.php                  │
  └────────────────────────────────┘
*/

wordpress_wpconfig_random_count_lines = 8
wordpress_wpconfig_count_characters   = 64


/*
  ┌────────────────────────────────┐
  │ rds                            │
  └────────────────────────────────┘
*/

db_family              = "mysql8.0"
db_engine               = "mysql"
db_instance_class       = "db.t4g.micro"
db_allocated_storage    = 20
db_major_engine_version = "8.0"

db_maintenance_window = "Mon:00:00-Mon:03:00"
db_backup_window      = "03:00-06:00"


db_name     = "dev_daria_nalimova_user_rds"
db_username = "admin"
db_port     = "3306"
