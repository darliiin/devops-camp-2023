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

variable "office_ip" {
  description = "Office ip"
  type        = string
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
  description = "number of available wordpress instances"
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
  │ env=specific configuration variables          │
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

variable "environment" {
  description = "Infra environment"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment could be one of dev | staging | prod"
  }
}

variable "tags" {
  description = "tags for the resource"
  type        = map(any)
}
