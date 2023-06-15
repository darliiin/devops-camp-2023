data "aws_route53_zone" "zone_record" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "acm_record" {
  for_each = {
    for domain_name in aws_acm_certificate.cert.domain_validation_options : domain_name.domain_name => {
      name   = domain_name.resource_record_name
      record = domain_name.resource_record_value
      type   = domain_name.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone_record.zone_id
}

resource "aws_route53_record" "alb_alias_record" {
  zone_id = data.aws_route53_zone.zone_record.zone_id
  name    = local.labels.domain_name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.alb]
}
