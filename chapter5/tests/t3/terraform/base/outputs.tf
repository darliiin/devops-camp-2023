output "nginx" {
  description = "Nginx configuration"
  value = {
    container_id       = module.nginx.container_id
    image_id           = module.nginx.image_id
  }
}


output "redis" {
  description = "Redis configuration"
  value = var.use_redis ? {
    container_id       = module.redis[0].container_id
    image_id           = module.redis[0].image_id
  } : {}
}
