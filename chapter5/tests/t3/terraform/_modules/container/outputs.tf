output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.container.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.image.id
}
