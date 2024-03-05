
environment = "dev"
how_many_az = 3
dns_zone = "spid.dev.notifichedigitali.it"
api_domains = ["api.pt"]
cdn_domains = []
apigw_custom_domains = []
  
pn_core_aws_account_id = "830192246553"
pn_confinfo_aws_account_id = "089813480515"
pn_confinfo_to_postel_vpcse = "com.amazonaws.vpce.eu-south-1.vpce-svc-01aaf09f48eb7db56"
pn_cost_anomaly_detection_email = "pn-irt-team@pagopa.it"
pn_cost_anomaly_detection_threshold = "30"
pn_postel_aws_account_id = "911845998067"


vpc_pn_confinfo_name = "PN ConfInfo"
vpc_pn_confinfo_primary_cidr = "10.2.0.0/16"
vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr = ["10.2.50.0/24","10.2.51.0/24","10.2.52.0/24"]
vpc_endpoints_pn_confinfo = ["sqs","logs","sns","kms","kinesis-streams","elasticloadbalancing","events","ecr.api","ecr.dkr","ssmmessages","ssm","ec2messages","ecs-agent","ecs-telemetry","ecs","secretsmanager","monitoring","xray"]

vpc_pn_confinfo_private_subnets_cidr = ["10.2.10.0/24","10.2.11.0/24","10.2.12.0/24"]
vpc_pn_confinfo_private_subnets_names = ["PN ConfInfo - ConfInfo Egress Subnet (dev) AZ 0","PN ConfInfo - ConfInfo Egress Subnet (dev) AZ 1","PN ConfInfo - ConfInfo Egress Subnet (dev) AZ 2"]
vpc_pn_confinfo_public_subnets_cidr = ["10.2.1.0/28","10.2.1.16/28","10.2.1.32/28"]
vpc_pn_confinfo_public_subnets_names = ["PN ConfInfo - Public Subnet (dev) AZ 0","PN ConfInfo - Public Subnet (dev) AZ 1","PN ConfInfo - Public Subnet (dev) AZ 2"]
vpc_pn_confinfo_internal_subnets_cidr = ["10.2.2.0/28","10.2.2.16/28","10.2.2.32/28","10.2.3.0/28","10.2.3.16/28","10.2.3.32/28","10.2.30.0/24","10.2.31.0/24","10.2.32.0/24","10.2.40.0/24","10.2.41.0/24","10.2.42.0/24","10.2.50.0/24","10.2.51.0/24","10.2.52.0/24"]
vpc_pn_confinfo_internal_subnets_names = ["PN ConfInfo - DataVault Ingress Subnet (dev) AZ 0","PN ConfInfo - DataVault Ingress Subnet (dev) AZ 1","PN ConfInfo - DataVault Ingress Subnet (dev) AZ 2","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (dev) AZ 0","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (dev) AZ 1","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (dev) AZ 2","PN ConfInfo - ConfInfo Subnet (dev) AZ 0","PN ConfInfo - ConfInfo Subnet (dev) AZ 1","PN ConfInfo - ConfInfo Subnet (dev) AZ 2","PN ConfInfo - PostelGW DMZ Subnet (dev) AZ 0","PN ConfInfo - PostelGW DMZ Subnet (dev) AZ 1","PN ConfInfo - PostelGW DMZ Subnet (dev) AZ 2","PN ConfInfo - AWS Services Subnet (dev) AZ 0","PN ConfInfo - AWS Services Subnet (dev) AZ 1","PN ConfInfo - AWS Services Subnet (dev) AZ 2"]

vpc_pn_confinfo_dvin_subnets_cidrs = ["10.2.2.0/28","10.2.2.16/28","10.2.2.32/28"]
vpc_pn_confinfo_ecssin_subnets_cidrs = ["10.2.3.0/28","10.2.3.16/28","10.2.3.32/28"]
vpc_pn_confinfo_confinfo_egres_subnets_cidrs = ["10.2.10.0/24","10.2.11.0/24","10.2.12.0/24"]
vpc_pn_confinfo_confinfo_subnets_cidrs = ["10.2.30.0/24","10.2.31.0/24","10.2.32.0/24"]
vpc_pn_confinfo_postel_subnets_cidrs = ["10.2.40.0/24","10.2.41.0/24","10.2.42.0/24"]





vpc_pn_spid_hub_name = "PN SpidHub"
vpc_pn_spid_hub_primary_cidr = "10.3.0.0/16"
vpc_pn_spid_hub_aws_services_interface_endpoints_subnets_cidr = []
vpc_endpoints_pn_spid_hub = []

vpc_pn_spid_hub_private_subnets_cidr = ["10.3.40.0/24","10.3.41.0/24","10.3.42.0/24"]
vpc_pn_spid_hub_private_subnets_names = ["PN SpidHub - Private Subnet (dev) AZ 0","PN SpidHub - Private Subnet (dev) AZ 1","PN SpidHub - Private Subnet (dev) AZ 2"]
vpc_pn_spid_hub_public_subnets_cidr = ["10.3.10.0/24","10.3.11.0/24","10.3.12.0/24"]
vpc_pn_spid_hub_public_subnets_names = ["PN SpidHub - Public Subnet (dev) AZ 0","PN SpidHub - Public Subnet (dev) AZ 1","PN SpidHub - Public Subnet (dev) AZ 2"]
vpc_pn_spid_hub_internal_subnets_cidr = []
vpc_pn_spid_hub_internal_subnets_names = []



