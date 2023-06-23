output "nginx" {
  description = "Nginx configuration"
  value       = var.use_nginx ? [module.nginx] : []
}

output "redis" {
  description = "Redis configuration"
  value       = var.use_redis ? [module.redis] : []
}
