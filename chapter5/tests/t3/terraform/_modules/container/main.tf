resource "docker_image" "image" {
  name         = var.image
  keep_locally = var.image_keep_locally
}

resource "docker_container" "container" {
  image = docker_image.image.image_id
  name  = var.name

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
    }
  }

  dynamic "volumes" {
    for_each = var.volumes
    content {
      host_path      = volumes.value.volumes_host_path
      container_path = volumes.value.volumes_container_path
    }
  }
}
