
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route53_zone" "account_root_dns_zone" {
  name         = "${var.dns_zone}."
  private_zone = false
}

locals {
  region = data.aws_availability_zones.available.id
  azs_names = slice(data.aws_availability_zones.available.names, 0, var.how_many_az)

  account_root_dns_zone_id = data.aws_route53_zone.account_root_dns_zone.zone_id
}

