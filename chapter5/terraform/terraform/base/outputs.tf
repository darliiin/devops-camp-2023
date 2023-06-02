output "instance_id" {
  value = [module.ec2_instance["1"].id, module.ec2_instance["2"].id]
}


output "efs_id" {
  value = module.efs.id
}

# output "alb_url" {
#   value = module.alb.lb_dns_name
# }
#
# output "rout_name" {
#   value = aws_route53_record.Aroute53.fqdn
# }

output "password" {
  sensitive = true
  value     = random_password.password.result
}
