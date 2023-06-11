#   ┌─────────────────────┐
#   │ alb                 │
#   └─────────────────────┘

module "alb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "8.6.1"
  name               = local.labels.wordpress_alb
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.target.id
  subnets            = data.aws_subnets.wordpress.ids
  security_groups    = [module.wordpress_alb_sg.security_group_id]

  target_groups = [
    {
      backend_port     = 80
      backend_protocol = "HTTP"
      target_type      = "instance"
      name             = local.labels.wordpress_alb_tg
      targets = {
        for i in range(var.wordpress_instances_count) : "my_target_${i + 1}" => {
          target_id = module.wordpress_ec2_instance[i].id
          port      = 80
        }
      }
    }
  ]

  tags = var.tags
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = aws_acm_certificate_validation.certificate.certificate_arn
      target_group_index = 0
    }
  ]
  depends_on = [module.wordpress_ec2_instance]
}
