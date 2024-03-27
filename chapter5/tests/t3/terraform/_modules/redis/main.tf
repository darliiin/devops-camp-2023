module "redis" {
  source = "../container"

  image              = var.container_image
  image_keep_locally = var.container_image_keep_locally
  name               = var.container_name
  ports              = var.container_ports
  volumes            = var.container_volumes

  client      = var.client
  project     = var.project
  environment = var.environment
}
