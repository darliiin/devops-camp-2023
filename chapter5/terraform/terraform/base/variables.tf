variable "cache_vpc_tags" {
  description = "VPC tags to place cache host into"
  type        = map(string)
  default = {
    Name = "default"
  }
}

variable "cache_availability_zones" {
  description = "Instance Availability Zones of the Cache host"
  type        = list(string)
}

variable "cache_engine" {
  description = "ElastiCache Engine, like redis"
  type        = string
}

/*
  ┌───────────────────┐
  │ instance sg       │
  └───────────────────┘
*/

variable "egress_rule_ec2_sg" {
  description = "Egress rule"
  type        = list(map(string))
}


/*
  ┌───────────────────┐
  │ instance          │
  └───────────────────┘
*/

variable "instance_names" {
  type    = set(string)
  default = ["1", "2"]
}

variable "name_ec2" {
  type    = list(string)
  default = ["1", "2"]
}

/*
  ┌───────────────────┐
  │ rds               │
  └───────────────────┘
*/

variable "db_name" {
  type        = string
  description = "db name"
}

variable "username" {
  type        = string
  description = "username"

}

variable "port" {
  type        = number
  description = "port"

}

/*
  ┌───────────────────┐
  │ rds sg            │
  └───────────────────┘
*/

variable "ingress_rule_rds_sg" {
  description = "Ingress rule"
  type        = list(map(string))
}

variable "egress_rule_rds_sg" {
  description = "Egress rule"
  type        = list(map(string))
}


/*
  ┌──────────────┐
  │ alb sg       │
  └──────────────┘
*/

variable "ingress_rule_alb_sg" {
  description = "Ingress rule"
  type        = list(map(string))
}

variable "egress_rule_alb_sg" {
  description = "Egress rule"
  type        = list(map(string))
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
