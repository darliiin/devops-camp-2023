output "instance_id" {
  value = module.wordpress_ec2_instance[*].id
}

output "efs_id" {
  value = module.efs.id
}

output "alb_url" {
  value = module.alb.lb_dns_name
}

output "record_name" {
  value = aws_route53_record.a_type_route53.fqdn
}

output "password_for_db" {
  sensitive = true
  value     = random_password.password_for_db.result
}
