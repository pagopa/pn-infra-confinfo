
output "ConfInfo_VpcId" {
  value = module.vpc_pn_confinfo.vpc_id
  description = "Id della VPC contenete i microservizi di PN che trattano informazioni Personali"
}

output "ConfInfo_VpcCidr" {
  value = var.vpc_pn_confinfo_primary_cidr
  description = "CIDR della VPC contenete i microservizi di PN che trattano informazioni Personali"
}

output "ConfInfo_EcsDefaultSecurityGroup" {
  value = ""
  description = "Default security group for ECS services"
}

output "ConfInfo_PnVPCDefaultSecurityGroup" {
  value = module.vpc_pn_confinfo.default_security_group_id
  description = "Default VPC security group"
}

output "ConfInfo_VpcEndpointsRequired" { 
  value       = "false"
  description = "AWS services endpoints already created"
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

output "ConfInfo_ApplicationLoadBalancerMetricsDimensionName" {
  value = replace( aws_lb.pn_confinfo_ecs_alb.arn, "/.*:[0-9]{12}:loadbalancer.app.(.*)/", "app/$1")
  description = "ECS cluster Application Load Balancer name used for metrics"
}


output "ConfInfo_ApplicationLoadBalancerAwsDns" {
  value = aws_lb.pn_confinfo_ecs_alb.dns_name 
  description = "ECS cluster Application Load Balancer AWS released DNS, can be used to call microservices"
}

output "ConfInfo_ApplicationLoadBalancerAwsDnsZoneId" {
  value = aws_lb.pn_confinfo_ecs_alb.zone_id 
  description = "ECS cluster Application Load Balancer AWS hosted Zone, usefull for aliases"
}

output "ConfInfo_ApplicationLoadBalancerListenerArn" {
  value = aws_lb_listener.pn_confinfo_ecs_alb_8080.arn
  description = "ECS cluster Application Load Balancer Listener ARN, attach here new microservice routing rule"
}


output "ConfInfo_WebappSecurityGroupId" {
  value = aws_security_group.vpc_pn_confinfo__secgrp_webapp.id
  description = "WebApp security group id"
}

output "ConfInfo_WebappSecurityGroupArn" {
  value = aws_security_group.vpc_pn_confinfo__secgrp_webapp.arn
  description = "WebApp security group ARN"
}


output "ConfInfo_ServiceEndpoint_ToDataVault" {
  value = aws_vpc_endpoint_service.pn_confinfo_dvin_endpoint_svc.service_name
  description = "Service endpoint for DataVault connections"
}
output "ConfInfo_ServiceEndpoint_ToExternalChannelSafeStorage" {
  value = aws_vpc_endpoint_service.pn_confinfo_ecssin_endpoint_svc.service_name
  description = "Service endpoint for External Channel and Safe storage connections"
}
output "ConfInfo_ServiceEndpoint_FromConsolidatore" {
  value = aws_vpc_endpoint_service.pn_confinfo_postel_endpoint_svc.service_name
  description = "Service endpoint for External Channel and Safe storage connections"
}

output "ConfInfo_PnCoreAwsAccountId" {
  value = var.pn_core_aws_account_id
  description = "AWS account id of pn-core. Usefull for resource policy and EventBridge Routes"
}

output "ConfInfo_PnCoreTargetEventBus" {
  value = "arn:aws:events:${var.aws_region}:${var.pn_core_aws_account_id}:event-bus/pn-CoreEventBus"
  description = "pn-core event bridge bus"
}





output "SpidHub_FrontEndVpcId" {
  value = module.vpc_pn_spid_hub.vpc_id
  description = "The Internet capable VPC Id"
}
output "SpidHub_FrontEndSubnets" {
  value = join(",", local.SpidHub_FrontEndSubnetsIds )
  description = "The FrontEnd NLB subnets ids"
}
output "SpidHub_FrontEndSubnetsCidrs" {
  value = join(",", local.SpidHub_FrontEndSubnetsCidrs )
  description = "The FrontEnd NLB subnets Cidr"
}

output "SpidHub_BackEndVpcId" {
  value = module.vpc_pn_spid_hub.vpc_id
  description = "The private VPC Id"
}
output "SpidHub_BackEndSubnets" {
  value = join(",", local.SpidHub_BackEndSubnetsIds )
  description = "The BackEnd NLB subnets ids"
}
output "SpidHub_BackEndSubnetsCidrs" {
  value = join(",", local.SpidHub_BackEndSubnetsCidrs )
  description = "The BackEnd NLB subnets Cidr"
}

output "SpidHub_InternalNlbIps" {
  value = join(",", local.SpidHub_InternalNlbIps )
  description = "Internal NLB IPs"
}

output "SpidHub_DomainName" {
  value = var.dns_zone
  description = "Spid services DNS"
}

output "SpidHub_HostedZoneId" {
  value = local.account_root_dns_zone_id
  description = "SPID DNS Hosted Zone Id"
}

output "SpidHub_HelpdeskAccountId" {
  value = var.pn_core_aws_account_id
  description = "Account id where helpdesk functionality are deployed"
}

