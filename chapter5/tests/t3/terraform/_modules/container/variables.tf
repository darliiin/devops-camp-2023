variable "image" {
  description = "Docker image name"
  type        = string
}

variable "tag" {
  description = "Docker image tag"
  type        = string
}

variable "image_keep_locally" {
  description = "If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation."
  type        = bool
  default     = false
}

variable "name" {
  description = "Docker container name"
  type        = string
}


variable "ports" {
  description = "Object of internal and external ports for the Docker container"
  type       = list(object({
    internal = number
    external = number
  }))
}

variable "volumes_host_path" {
  description = "Path to volume on host (local machine)"
  type        = string
  default     = ""
}

variable "volumes_container_path" {
  description = "Path to volume inside container"
  type        = string
  default     = ""
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
