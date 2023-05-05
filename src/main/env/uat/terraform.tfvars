
environment = "uat"
how_many_az = 3
dns_zone = "spid.uat.notifichedigitali.it"
api_domains = ["api.pt"]
cdn_domains = []
apigw_custom_domains = []
  
pn_core_aws_account_id = "644374009812"
pn_confinfo_aws_account_id = "956319218727"
pn_confinfo_to_postel_vpcse = "com.amazonaws.vpce.eu-south-1.vpce-svc-01aaf09f48eb7db56"
pn_postel_aws_account_id = "911845998067"


vpc_pn_confinfo_name = "PN ConfInfo"
vpc_pn_confinfo_primary_cidr = "10.7.0.0/16"
vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr = ["10.7.50.0/24","10.7.51.0/24","10.7.52.0/24"]
vpc_endpoints_pn_confinfo = ["sqs","logs","sns","kms","kinesis-streams","elasticloadbalancing","events","ecr.api","ecr.dkr","ssmmessages","ssm","ec2messages","ecs-agent","ecs-telemetry","ecs","secretsmanager","monitoring","xray"]

vpc_pn_confinfo_private_subnets_cidr = ["10.7.10.0/24","10.7.11.0/24","10.7.12.0/24"]
vpc_pn_confinfo_private_subnets_names = ["PN ConfInfo - ConfInfo Egress Subnet (uat) AZ 0","PN ConfInfo - ConfInfo Egress Subnet (uat) AZ 1","PN ConfInfo - ConfInfo Egress Subnet (uat) AZ 2"]
vpc_pn_confinfo_public_subnets_cidr = ["10.7.1.0/28","10.7.1.16/28","10.7.1.32/28"]
vpc_pn_confinfo_public_subnets_names = ["PN ConfInfo - Public Subnet (uat) AZ 0","PN ConfInfo - Public Subnet (uat) AZ 1","PN ConfInfo - Public Subnet (uat) AZ 2"]
vpc_pn_confinfo_internal_subnets_cidr = ["10.7.2.0/28","10.7.2.16/28","10.7.2.32/28","10.7.3.0/28","10.7.3.16/28","10.7.3.32/28","10.7.30.0/24","10.7.31.0/24","10.7.32.0/24","10.7.40.0/24","10.7.41.0/24","10.7.42.0/24","10.7.50.0/24","10.7.51.0/24","10.7.52.0/24"]
vpc_pn_confinfo_internal_subnets_names = ["PN ConfInfo - DataVault Ingress Subnet (uat) AZ 0","PN ConfInfo - DataVault Ingress Subnet (uat) AZ 1","PN ConfInfo - DataVault Ingress Subnet (uat) AZ 2","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (uat) AZ 0","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (uat) AZ 1","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (uat) AZ 2","PN ConfInfo - ConfInfo Subnet (uat) AZ 0","PN ConfInfo - ConfInfo Subnet (uat) AZ 1","PN ConfInfo - ConfInfo Subnet (uat) AZ 2","PN ConfInfo - PostelGW DMZ Subnet (uat) AZ 0","PN ConfInfo - PostelGW DMZ Subnet (uat) AZ 1","PN ConfInfo - PostelGW DMZ Subnet (uat) AZ 2","PN ConfInfo - AWS Services Subnet (uat) AZ 0","PN ConfInfo - AWS Services Subnet (uat) AZ 1","PN ConfInfo - AWS Services Subnet (uat) AZ 2"]

vpc_pn_confinfo_dvin_subnets_cidrs = ["10.7.2.0/28","10.7.2.16/28","10.7.2.32/28"]
vpc_pn_confinfo_ecssin_subnets_cidrs = ["10.7.3.0/28","10.7.3.16/28","10.7.3.32/28"]
vpc_pn_confinfo_confinfo_egres_subnets_cidrs = ["10.7.10.0/24","10.7.11.0/24","10.7.12.0/24"]
vpc_pn_confinfo_confinfo_subnets_cidrs = ["10.7.30.0/24","10.7.31.0/24","10.7.32.0/24"]
vpc_pn_confinfo_postel_subnets_cidrs = ["10.7.40.0/24","10.7.41.0/24","10.7.42.0/24"]





vpc_pn_spid_hub_name = "PN SpidHub"
vpc_pn_spid_hub_primary_cidr = "10.8.0.0/16"
vpc_pn_spid_hub_aws_services_interface_endpoints_subnets_cidr = []
vpc_endpoints_pn_spid_hub = []

vpc_pn_spid_hub_private_subnets_cidr = ["10.8.40.0/24","10.8.41.0/24","10.8.42.0/24"]
vpc_pn_spid_hub_private_subnets_names = ["PN SpidHub - Private Subnet (uat) AZ 0","PN SpidHub - Private Subnet (uat) AZ 1","PN SpidHub - Private Subnet (uat) AZ 2"]
vpc_pn_spid_hub_public_subnets_cidr = ["10.8.10.0/24","10.8.11.0/24","10.8.12.0/24"]
vpc_pn_spid_hub_public_subnets_names = ["PN SpidHub - Public Subnet (uat) AZ 0","PN SpidHub - Public Subnet (uat) AZ 1","PN SpidHub - Public Subnet (uat) AZ 2"]
vpc_pn_spid_hub_internal_subnets_cidr = []
vpc_pn_spid_hub_internal_subnets_names = []



