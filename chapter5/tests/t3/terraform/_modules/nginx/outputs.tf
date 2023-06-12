output "container_id" {
  description = "ID of the Docker container"
  value       = module.nginx.container_id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = module.nginx.image_id
}
