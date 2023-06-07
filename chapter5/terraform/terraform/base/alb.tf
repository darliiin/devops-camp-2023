#   ┌─────────────────────┐
#   │ alb                 │
#   └─────────────────────┘

module "alb" {
  source = "terraform-aws-modules/alb/aws"
  name   = local.labels.wordpress_alb

  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.target.id
  subnets         = data.aws_subnets.wordpress.ids
  security_groups = [module.wordpress_alb_sg.security_group_id]

  #    target_groups = [
  #     {
  #       name             = local.labels.wordpress_alb_tg
  #       backend_protocol = "HTTP"
  #       backend_port     = 80
  #       target_type      = "instance"
  #       targets = {
  #         my_target = {
  #           target_id = data.aws_instance.ec2-0.id
  #           port      = 80
  #         }
  #         my_other_target = {
  #           target_id = data.aws_instance.ec2-1.id
  #           port      = 80
  #         }
  #       }
  #     }
  #   ]
  target_groups = [
    {
      name             = local.labels.wordpress_alb_tg
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        for instance in module.wordpress_ec2_instance : "my_target_${instance.id}" => {
          target_id = instance.id
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
}
