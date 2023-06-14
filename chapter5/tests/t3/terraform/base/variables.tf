/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ nginx configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */

variable "use_nginx" {
  description = "Do you need to use nginx?"
  type        = bool
  default     = true
}

variable "nginx" {
  type = object({
    image           = string
    tag             = string
    container_name  = optional(string, null)
    container_ports = optional(list(object({
      internal = number
      external = number
    })))
    keep_locally = bool
    container_volumes = optional(list(object({
      volumes_host_path      = string
      volumes_container_path = string
    })))
    volumes_container_path = string
  })
  default = {
    image                  = "nginx"
    tag                    = "latest"
    keep_locally           = false
    volumes_container_path = "/usr/share/nginx/html"
  }
}

/* 
  ┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │ redis configuration variables                                                                                    │
  └──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
 */


variable "use_redis" {
  description = "Do you need to use redis?"
  type        = bool
  default     = false
}

variable "redis" {
  type = object({
    image           = string
    tag             = string
    container_name  = optional(string, null)
    container_ports = optional(list(object({
      internal = number
      external = number
    })))
    keep_locally = bool
    container_volumes = optional(list(object({
      volumes_host_path      = string
      volumes_container_path = string
    })))
    volumes_host_path      = string
    volumes_container_path = string
  })
  default = {
    image = "redis"
    tag   = "latest"
    container_ports = [
      {
        internal = 6379
        external = 6379
      }
    ]
    keep_locally           = false
    volumes_host_path      = ""
    volumes_container_path = ""
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
