module "redis" {
  source = "../container"

  client      = var.client
  project     = var.project
  environment = var.environment

  image              = var.container_image
  tag                = var.container_tag
  image_keep_locally = var.container_image_keep_locally
  name               = var.container_name
  ports              = var.container_ports
  volumes            = var.container_volumes
}
