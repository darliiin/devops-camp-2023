/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "nginx" {
  type = object({
    image           = string
    container_name  = optional(string)
    container_ports = optional(map(string))
    keep_locally    = bool
  })
  default = {
    image        = "nginx:latest"
    keep_locally = false
  }
}


/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */


variable "use_redis" {
  description = "Do you need to speed up the perf using redis?"
  type        = bool
  default     = false
}

variable "redis" {
  type = object({
    image           = string
    container_name  = optional(string)
    container_ports = optional(map(string))
    keep_locally    = bool
  })
  default = {
    image = "redis:latest"
    container_ports = {
      internal = 6379
      external = 6379
    }
    keep_locally = false
  }
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ env=specific configuration variables                                                                             │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
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
