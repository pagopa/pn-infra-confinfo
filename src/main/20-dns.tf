  
data "aws_route53_zone" "base_domain_name" {
  name         = "${var.dns_zone}."
  private_zone = false
}

provider "aws" {
  alias  = "aws-us-east-1"
  region = "us-east-1"
}

module "acm_api" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.3.2"

  for_each = var.api_domains

  providers = {
    aws = aws
  }

  wait_for_validation = true
  
  domain_name = "${each.key}.${var.dns_zone}"
  zone_id     = data.aws_route53_zone.base_domain_name.zone_id

  subject_alternative_names = []

  tags = {
    Name = "${each.key}.${var.dns_zone}"
  }
}

resource "aws_api_gateway_domain_name" "apigw_custom_domain" {
  for_each = var.apigw_custom_domains

  domain_name = "${each.key}.${var.dns_zone}"
  regional_certificate_arn = module.acm_api[each.key].acm_certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "apigw_custom_domain_dns" {
  for_each  = var.apigw_custom_domains

  name      = "${each.key}.${var.dns_zone}"
  type      = "A"
  zone_id   = data.aws_route53_zone.base_domain_name.zone_id
  
  alias {
    evaluate_target_health = false
    name                   = aws_api_gateway_domain_name.apigw_custom_domain[each.key].regional_domain_name
    zone_id                = aws_api_gateway_domain_name.apigw_custom_domain[each.key].regional_zone_id
  }
}

module "acm_cdn" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.3.2"

  for_each = var.cdn_domains

  providers = {
    aws = aws.aws-us-east-1
  }

  wait_for_validation = true
  
  domain_name = "${each.key}.${var.dns_zone}"
  zone_id     = data.aws_route53_zone.base_domain_name.zone_id

  subject_alternative_names = []

  tags = {
    Name = "${each.key}.${var.dns_zone}"
  }
}
