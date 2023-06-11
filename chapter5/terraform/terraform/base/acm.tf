#   ┌─────────────────────┐
#   │ acm certificate     │
#   └─────────────────────┘

resource "aws_acm_certificate" "cert" {
  domain_name       = local.labels.wordpress_acm
  validation_method = "DNS"
}

data "aws_route53_zone" "zone_record" {
  name         = "saritasa-camps.link"
  private_zone = false
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone_record.zone_id
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = values(aws_route53_record.acm_validation)[*].fqdn

  depends_on = [aws_route53_record.acm_validation]
}

resource "aws_route53_record" "alb_alias_record" {
  zone_id = data.aws_route53_zone.zone_record.zone_id
  name    = aws_acm_certificate.cert.domain_name
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.alb]
}
