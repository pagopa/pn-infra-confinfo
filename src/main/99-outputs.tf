
output "ConfInfo_VpcId" {
  value = module.vpc_pn_confinfo.vpc_id
  description = "Id della VPC contenete i microservizi di PN che trattano informazioni Personali"
}

output "ConfInfo_VpcCidr" {
  value = var.vpc_pn_confinfo_primary_cidr
  description = "CIDR della VPC contenete i microservizi di PN che trattano informazioni Personali"
}


output "ConfInfo_VpcSubnets" {
  value = local.ConfInfo_SubnetsIds
}

output "ConfInfo_VpcSubnetsCidrs" {
  value = local.ConfInfo_SubnetsCidrs
}

output "ConfInfo_VpcEgressSubnetsIds" {
  value = local.ConfInfo_EgressSubnetsIds
}

output "ConfInfo_VpcEgressSubnetsCidrs" {
  value = local.ConfInfo_EgressSubnetsCidrs
}


output "ConfInfo_ApplicationLoadBalancerArn" {
  value = aws_lb.pn_confinfo_ecs_alb.arn
  description = "ECS cluster Application Load Balancer ARN, attach microservice listeners here"
}

output "ConfInfo_ApplicationLoadBalancerAwsDns" {
  value = aws_lb.pn_confinfo_ecs_alb.dns_name 
  description = "ECS cluster Application Load Balancer AWS released DNS, can be used to call microservices"
}

output "ConfInfo_ApplicationLoadBalancerAwsDnsZoneId" {
  value = aws_lb.pn_confinfo_ecs_alb.zone_id 
  description = "ECS cluster Application Load Balancer AWS hosted Zone, usefull for aliases"
}

