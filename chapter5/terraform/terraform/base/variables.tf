variable "vpc_tags" {
  description = "VPC tags to place host into"
  type        = map(string)
  default = {
    Name = "default"
  }
}

variable "availability_zones" {
  description = "Instance Availability Zones of host"
  type        = list(string)
}

variable "engine" {
  description = "Engine, like redis"
  type        = string
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

variable "wordpress_instances_count" {
  description = "number of available instances"
  type        = number
}

variable "instance_ami" {
  description = "ami for instances"
  type        = string
}

variable "instance_type" {
  description = "instance type"
  type        = string
}

/*
  ┌───────────────────┐
  │ rds               │
  └───────────────────┘
*/

variable "family_rds" {
  type        = string
  description = "family rds"
}

variable "engine_rds" {
  type        = string
  description = "engine rds"
}

variable "instance_class_rds" {
  type        = string
  description = "instance class rds"
}

variable "allocated_storage_rds" {
  type        = number
  description = "allocated storage rds"
}

variable "major_engine_version_rds" {
  type        = string
  description = "major engine version rds"
}

variable "maintenance_window_rds" {
  type        = string
  description = "maintenance window"
}

variable "backup_window_rds" {
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
