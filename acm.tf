# SSL Certificate
resource "aws_acm_certificate" "ssl_certificate" {
  provider                  = aws.acm_provider
  domain_name               = "net.${var.www_domain_name}"
  subject_alternative_names = ["*.${var.www_domain_name}"]
  validation_method = var.validation_method
 tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Uncomment the validation_record_fqdns line if you do DNS validation instead of Email.
resource "aws_acm_certificate_validation" "cert_validation" {
 certificate_arn         = aws_acm_certificate.ssl_certificate.arn
 validation_record_fqdns = [for record in aws_route53_record.cert_validation: record.fqdn]
}

