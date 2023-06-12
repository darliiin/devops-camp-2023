output "container_id" {
  description = "ID of the Docker container"
  value       = module.redis.container_id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = module.redis.image_id
}
