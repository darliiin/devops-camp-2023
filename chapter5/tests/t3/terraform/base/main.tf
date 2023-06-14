module "nginx" {
  source = "./modules/nginx"
  count  = var.use_nginx ? 1 : 0

  container_image              = var.nginx.image
  container_name               = var.nginx.container_name
  container_tag                = var.nginx.tag
  container_ports              = var.nginx.container_ports
  container_image_keep_locally = var.nginx.keep_locally
  container_volumes = [
    {
      volumes_host_path      = "${abspath(path.root)}/../../${var.environment}"
      volumes_container_path = var.nginx.volumes_container_path
    }
  ]
  client      = var.client
  project     = var.project
  environment = var.environment
}

module "redis" {
  source = "./modules/redis"
  count  = var.use_redis ? 1 : 0

  container_image              = var.redis.image
  container_name               = var.redis.container_name
  container_tag                = var.redis.tag
  container_ports              = var.redis.container_ports
  container_image_keep_locally = var.redis.keep_locally
  container_volumes = [
    {
      volumes_host_path      = "${abspath(path.root)}/../../${var.environment}"
      volumes_container_path = var.redis.volumes_container_path
    }
  ]
  client                       = var.client
  project                      = var.project
  environment                  = var.environment

  depends_on = [module.nginx]
}
