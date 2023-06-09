resource "aws_acm_certificate" "certificate" {
  domain_name = data.aws_route53_zone.web_platform.name
  subject_alternative_names = [
    "*.${data.aws_route53_zone.web_platform.name}",
    "*.${var.region}.${data.aws_route53_zone.web_platform.name}",
    "${var.region}.${data.aws_route53_zone.web_platform.name}",

  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for record in aws_acm_certificate.certificate.domain_validation_options : record.domain_name => {
      name   = record.resource_record_name
      record = record.resource_record_value
      type   = record.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.web_platform.zone_id
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_acm_certificate" "certificate" {
  count             = contains(["uat", "prod-dr"], var.environment) ? 1 : 0
  domain_name       = "*.${var.environment}.embarkvet"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}