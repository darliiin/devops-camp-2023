variable "container_image" {
  description = "Value of the name for the Docker container"
  type        = string
}

variable "container_image_keep_locally" {
  description = "If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation."
  type        = bool
  default     = false
}

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  validation {
    condition     = can(regex("^(saritasa-devops-camps-2023-).*", var.container_name))
    error_message = "Container name should be prefixed with saritasa-devops-camps-2023-"
  }
}

variable "container_ports" {
  description = "Value of the name for the Docker container"
  type        = map(any)
  default = {
    internal = 6379
    external = 6379
  }
  validation {
    condition     = var.container_ports.internal == "6379" && var.container_ports.external == "6379"
    error_message = "Container internal port should be less 1000 and external above or equal to 8000"
  }
}

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
