locals {
  rendered_index_html = templatefile("${path.module}/templates/index.html.tftpl", {
    environment = var.environment,
    client      = var.client
  })
}

module "nginx" {
  source = "../container"

  image              = var.container_image
  image_keep_locally = var.container_image_keep_locally
  name               = var.container_name
  ports              = var.container_ports
  volumes            = var.container_volumes

  client      = var.client
  project     = var.project
  environment = var.environment

  depends_on = [
    null_resource.index_page
  ]
}

resource "null_resource" "index_page" {
  provisioner "local-exec" {
    command = "mkdir ${path.module}/../../../${var.environment} && cat > ${path.module}/../../../${var.environment}/index.html  <<EOL\n${local.rendered_index_html}\nEOL"
  }
}

resource "null_resource" "delete_index_page" {
  triggers = {
    path = "${path.module}/../../../${var.environment}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.triggers.path}"
  }
}
