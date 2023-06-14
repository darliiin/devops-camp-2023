variable "container_image" {
  description = "Docker image name"
  type        = string
}

variable "container_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "container_image_keep_locally" {
  description = "If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation."
  type        = bool
  default     = false
}

variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
}

variable "container_ports" {
  description = "Object of internal and external ports for the Docker container"
  type = list(object({
    internal = number
    external = number
  }))
}

variable "container_volumes" {
  description = "Volumes for the redis container"
  type = list(object({
    volumes_host_path      = string
    volumes_container_path = string
  }))
  default = []
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
