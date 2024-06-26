variable "wordpress_vpc_tags" {
  description = "VPC tags to place host into"
  type        = map(string)
  default = {
    Name = "default"
  }
}

/*
  ┌───────────────┐
  │ office ip     │
  └───────────────┘
*/

variable "allowed_ssh_ips" {
  description = "IP list for ssh access"
  type        = list(string)
}

/*
  ┌───────────────────┐
  │ instance          │
  └───────────────────┘
*/

variable "wordpress_availability_zones" {
  description = "Instance Availability Zones of host"
  type        = list(string)
}

variable "wordpress_instances_count" {
  description = "number of desired wordpress instances"
  type        = number
}

variable "wordpress_instances_type" {
  description = "wordpress instances type"
  type        = string
}

variable "wordpress_instances_ami" {
  description = "ami for wordpress instances"
  type        = string
}

/*
  ┌────────────────────────────────┐
  │ wp-config.php                  │
  └────────────────────────────────┘
*/

variable "wordpress_wpconfig_secrets_length" {
  description = "number of characters authentication Unique Keys and Salts for wordpress"
  type        = number
}

variable "wordpress_random_wpconfig_secrets" {
  description = "Random authentication Unique Keys and Salts for wp-config.php"
  type        = list(string)
}

/*
  ┌───────────────────┐
  │ rds               │
  └───────────────────┘
*/

variable "db_family" {
  type        = string
  description = "family rds"
}

variable "db_engine" {
  type        = string
  description = "engine rds"
}

variable "db_instance_class" {
  type        = string
  description = "instance class rds"
}

variable "db_allocated_storage" {
  type        = number
  description = "allocated storage rds"
}

variable "db_major_engine_version" {
  type        = string
  description = "major engine version rds"
}

variable "db_maintenance_window" {
  type        = string
  description = "maintenance window"
}

variable "db_backup_window" {
  type        = string
  description = "backup window"
}

variable "db_name" {
  type        = string
  description = "database name"
}

variable "db_username" {
  type        = string
  description = "database username"

}

variable "db_port" {
  type        = number
  description = "database port"
}

/*
  ┌───────────────────────────────────────────────┐
  │ hosted zone name                              │
  └───────────────────────────────────────────────┘
*/

variable "hosted_zone_name" {
  type        = string
  description = "hosted zone name"
}

/* 
  ┌───────────────────────────────────────────────┐
  │ env-specific configuration variables          │
  └───────────────────────────────────────────────┘
 */

variable "client" {
  description = "Client username"
  type        = string
}

variable "project" {
  description = "Project we're working on"
  type        = string
}

variable "domain_name" {
  description = "Domain name used for website"
  type        = string
}

variable "environment" {
  description = "Infra environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment could be one of dev | staging | prod"
  }
}
