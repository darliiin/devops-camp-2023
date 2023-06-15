#   ┌─────────────────────┐
#   │ acm certificate     │
#   └─────────────────────┘

resource "aws_acm_certificate" "cert" {
  domain_name       = local.labels.domain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "certificate_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = values(aws_route53_record.acm_record)[*].fqdn

  depends_on = [aws_route53_record.acm_record]
}
