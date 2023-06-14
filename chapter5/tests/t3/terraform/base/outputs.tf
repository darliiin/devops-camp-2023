output "nginx" {
  description = "Nginx configuration"
    value = var.use_nginx ? [module.nginx] : []
}

output "redis" {
  description = "Redis configuration"
  value = var.use_redis ? [module.redis] : []
#   value = var.use_redis ? {
#     container_id = module.redis[0].container_id
#     image_id     = module.redis[0].image_id
#   } : {}
}
