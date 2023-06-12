module "nginx" {
  source = "./modules/nginx"
  count  = var.use_nginx ? 1 : 0

  container_image              = var.nginx.image
  container_name               = var.use_nginx ? (var.nginx.container_name != "" ? var.nginx.container_name : null) : null
  container_tag                = var.nginx.tag
  container_ports              = var.use_nginx ? (length(var.nginx.container_ports) > 0 ? var.nginx.container_ports : null) : null
  container_image_keep_locally = var.nginx.keep_locally
  nginx_volumes_container_path = var.nginx_volumes_container_path
  client                       = var.client
  project                      = var.project
  environment                  = var.environment
}

module "redis" {
  source = "./modules/redis"
  count  = var.use_redis ? 1 : 0

  container_image              = var.redis.image
  container_name               = var.use_redis ? var.redis.container_name : null
  container_tag                = var.redis.tag
  container_ports              = var.use_redis ? var.redis.container_ports : null
  container_image_keep_locally = var.redis.keep_locally
  client                       = var.client
  project                      = var.project
  environment                  = var.environment

  depends_on = [module.nginx]
}
