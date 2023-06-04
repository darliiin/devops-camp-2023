module "nginx" {
  source = "../container"

  client      = var.client
  project     = var.project
  environment = var.environment

  container_image              = var.container_image
  container_image_keep_locally = var.container_image_keep_locally
  container_name               = var.container_name
  container_ports = {
    internal = var.container_ports.internal
    external = var.container_ports.external
  }

  volumes_host_path      = "${abspath(path.root)}/../../${var.environment}"
  volumes_container_path = "/usr/share/nginx/html"

  depends_on = [
    null_resource.index_page
  ]
}
resource "null_resource" "index_page" {
  provisioner "local-exec" {
    command = "mkdir ../../${var.environment} && cat > ../../${var.environment}/index.html  <<EOL\n${local.rendered_index_html}\nEOL"
  }
}
