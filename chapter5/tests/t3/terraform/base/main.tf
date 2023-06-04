module "nginx" {
  source = "./modules/nginx"

  container_image              = var.nginx.image
  container_name               = var.nginx.container_name != "" ? var.nginx.container_name : null
  container_ports              = var.nginx.container_ports != "" ? var.nginx.container_ports : null
  container_image_keep_locally = var.nginx.keep_locally
  client                       = var.client
  project                      = var.project
  environment                  = var.environment
}

module "redis" {
  source = "./modules/redis"
  count  = var.use_redis ? 1 : 0

  container_image              = var.redis.image
  container_name               = var.use_redis ? var.redis.container_name : null
  container_ports              = var.use_redis ? var.redis.container_ports : null
  container_image_keep_locally = var.redis.keep_locally
  client                       = var.client
  project                      = var.project
  environment                  = var.environment

  depends_on = [module.nginx]
}
