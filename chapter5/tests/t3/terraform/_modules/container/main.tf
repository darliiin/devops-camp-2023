resource "docker_image" "container" {
  name         = var.container_image
  keep_locally = var.container_image_keep_locally
}

resource "docker_container" "container" {
  image = docker_image.container.image_id
  name  = var.container_name
  ports {
    internal = var.container_ports.internal
    external = var.container_ports.external
  }

  volumes {
    host_path      = var.volumes_host_path
    container_path = var.volumes_container_path
  }

  provisioner "local-exec" {
    command     = "./delete.sh"
     working_dir = path.module
    when        = destroy
  }
}
