data "aws_route53_zone" "hosted_zone" {
  name = var.www_domain_name
}

# resource "aws_route53_record" "root-b" {
#   zone_id         = data.aws_route53_zone.hosted_zone.zone_id
#   name            = "diksha.${var.www_domain_name}"
#   type            = "A"
#   ttl             = "300"
 
#   allow_overwrite = true
# }

resource "aws_route53_record" "net-a" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "net.${var.www_domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www_s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.www_s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


# Uncomment the below block if you are doing certificate validation using DNS instead of Email.
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.hosted_zone.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
    }


