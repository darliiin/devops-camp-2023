module "redis" {
  source = "../container"

  client      = var.client
  project     = var.project
  environment = var.environment

  container_image              = var.container_image
  container_image_keep_locally = var.container_image_keep_locally
  container_name               = var.container_name
  container_ports              = var.container_ports
}
