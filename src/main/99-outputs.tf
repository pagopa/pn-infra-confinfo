
output "ConfInfo_VpcId" {
  value = module.vpc_pn_confinfo.vpc_id
  description = "Id della VPC contenete i microservizi di PN che trattano informazioni Personali"
}

output "ConfInfo_VpcCidr" {
  value = var.vpc_pn_confinfo_primary_cidr
  description = "CIDR della VPC contenete i microservizi di PN che trattano informazioni Personali"
}


data "aws_subnet" "ConfInfo_SubnetsIds" {
  count = 3

  filter {
    name   = "tag:Name"
    values = [
      "PN ConfInfo - ConfInfo Subnet (dev) AZ ${count.index}"
    ]
  }
}

output "ConfInfo_SubnetsIds" {
  value = data.aws_subnet.ConfInfo_SubnetsIds.*.id
}

output "ConfInfo_SubnetsCidr" {
  value = data.aws_subnet.ConfInfo_SubnetsIds.*.cidr_block
}



data "aws_subnet" "ConfInfo_EgressSubnetsIds" {
  count = 3

  filter {
    name   = "tag:Name"
    values = [
      "PN ConfInfo - ConfInfo Egress Subnet (dev) AZ ${count.index}"
    ]
  }
}

output "ConfInfo_EgressSubnetsIds" {
  value = data.aws_subnet.ConfInfo_EgressSubnetsIds.*.id
}

output "ConfInfo_EgressSubnetsCidr" {
  value = data.aws_subnet.ConfInfo_EgressSubnetsIds.*.cidr_block
}


