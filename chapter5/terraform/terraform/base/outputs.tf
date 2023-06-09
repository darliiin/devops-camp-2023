output "instance_id" {
  description = "Id wordpress instances"
  value       = module.wordpress_ec2_instance[*].id
}

output "efs_id" {
  description = "Id wordpress efs"
  value       = module.efs.id
}

output "alb_url" {
  description = "Alb url address"
  value       = module.alb.lb_dns_name
}

output "record_name" {
  description = "Fqdn of the record"
  value       = aws_route53_record.a_type_route53.fqdn
}

output "db_password" {
  sensitive   = true
  description = "Database password for admin user"
  value       = module.wordpress_rds.db_instance_password
}
