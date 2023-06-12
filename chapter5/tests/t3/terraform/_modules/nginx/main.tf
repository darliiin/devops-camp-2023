module "nginx" {
  source = "../container"

  client      = var.client
  project     = var.project
  environment = var.environment

  image                  = var.container_image
  tag                    = var.container_tag
  image_keep_locally     = var.container_image_keep_locally
  name                   = var.container_name
  ports                  = var.container_ports
  volumes_host_path      = local.nginx_volumes_host_path
  volumes_container_path = var.nginx_volumes_container_path

  depends_on = [
    null_resource.index_page
  ]
}

locals {
  rendered_index_html = templatefile("${path.module}/templates/index.html.tftpl", {
    environment = var.environment,
    client      = var.client
  })
  nginx_volumes_host_path = "${abspath(path.root)}/../../${var.environment}"
}

resource "null_resource" "index_page" {
  provisioner "local-exec" {
    command = "mkdir ../../${var.environment} && cat > ../../${var.environment}/index.html  <<EOL\n${local.rendered_index_html}\nEOL"
  }
}

resource "null_resource" "delete_index_page" {
  triggers = {
    path = "../../${var.environment}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.triggers.path}"
  }
}

