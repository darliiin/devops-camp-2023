resource "docker_image" "image" {
  name         = "${var.image}:${var.tag}"
  keep_locally = var.image_keep_locally
}

resource "docker_container" "container" {
  image = docker_image.image.image_id
  name  = var.name

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports .value.external
    }
  }

  volumes {
    host_path      = var.volumes_host_path
    container_path = var.volumes_container_path
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf '${self.volumes.*.host_path[0]}'"
  }
}
