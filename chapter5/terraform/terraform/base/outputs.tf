output "instance_id" {
  description = "ID wordpress instances"
  value       = module.wordpress_ec2_instance[*].id
}

output "efs_id" {
  description = "ID wordpress EFS"
  value       = module.efs.id
}

output "alb_url" {
  description = "ALB url address"
  value       = module.alb.lb_dns_name
}

output "wordpress_fqdn" {
  description = "FQDN of the record"
  value       = aws_route53_record.alb_alias_record.fqdn
}

output "db_password" {
  sensitive   = true
  description = "Database password for admin user"
  value       = module.wordpress_rds.db_instance_password
}
