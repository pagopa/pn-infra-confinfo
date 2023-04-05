
output "ConfInfo_VpcId" {
  value = module.vpc_pn_confinfo.vpc_id
  description = "Id della VPC contenete i microservizi di PN che trattano informazioni Personali"
}

output "ConfInfo_VpcCidr" {
  value = var.vpc_pn_confinfo_primary_cidr
  description = "CIDR della VPC contenete i microservizi di PN che trattano informazioni Personali"
}


output "ConfInfo_SubnetsIds" {
  value = local.ConfInfo_SubnetsIds
}

output "ConfInfo_SubnetsCidrs" {
  value = local.ConfInfo_SubnetsCidrs
}

output "ConfInfo_EgressSubnetsIds" {
  value = local.ConfInfo_EgressSubnetsIds
}

output "ConfInfo_EgressSubnetsCidrs" {
  value = local.ConfInfo_EgressSubnetsCidrs
}


