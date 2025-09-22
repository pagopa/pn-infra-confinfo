
environment = "hotfix"
how_many_az = 3
dns_zone = "spid.hotfix.notifichedigitali.it"
api_domains = ["api.pt"]
cdn_domains = []
apigw_custom_domains = []
  
pn_core_aws_account_id = "207905393513"
pn_confinfo_aws_account_id = "839620963891"
pn_confinfo_to_postel_vpcse = "com.amazonaws.vpce.eu-south-1.vpce-svc-01aaf09f48eb7db56"
pn_cost_anomaly_detection_email = "pn-irt-team@pagopa.it"
pn_cost_anomaly_detection_threshold = "10"
iam_ext_roles_config = {"SendExtAdmin":{"managed_policies":["AdministratorAccess"]},"SendExtReadOnly":{"managed_policies":["ReadOnlyAccess"],"inline_policies":[{"name":"KmsDecrypt"}]}}
pn_postel_aws_account_id = "554102482368"
pn_cicd_aws_account_id = "911845998067"


vpc_pn_confinfo_name = "PN ConfInfo"
vpc_pn_confinfo_primary_cidr = "10.13.0.0/16"
vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr = ["10.13.50.0/24","10.13.51.0/24","10.13.52.0/24"]
vpc_endpoints_pn_confinfo = ["sqs","logs","sns","kms","kinesis-streams","elasticloadbalancing","events","ecr.api","ecr.dkr","ssmmessages","ssm","ec2messages","ecs-agent","ecs-telemetry","ecs","secretsmanager","monitoring","xray"]

vpc_pn_confinfo_private_subnets_cidr = ["10.13.10.0/24","10.13.11.0/24","10.13.12.0/24"]
vpc_pn_confinfo_private_subnets_names = ["PN ConfInfo - ConfInfo Egress Subnet (hotfix) AZ 0","PN ConfInfo - ConfInfo Egress Subnet (hotfix) AZ 1","PN ConfInfo - ConfInfo Egress Subnet (hotfix) AZ 2"]
vpc_pn_confinfo_public_subnets_cidr = ["10.13.1.0/28","10.13.1.16/28","10.13.1.32/28"]
vpc_pn_confinfo_public_subnets_names = ["PN ConfInfo - Public Subnet (hotfix) AZ 0","PN ConfInfo - Public Subnet (hotfix) AZ 1","PN ConfInfo - Public Subnet (hotfix) AZ 2"]
vpc_pn_confinfo_internal_subnets_cidr = ["10.13.2.0/28","10.13.2.16/28","10.13.2.32/28","10.13.3.0/28","10.13.3.16/28","10.13.3.32/28","10.13.30.0/24","10.13.31.0/24","10.13.32.0/24","10.13.40.0/24","10.13.41.0/24","10.13.42.0/24","10.13.50.0/24","10.13.51.0/24","10.13.52.0/24","10.13.60.0/24","10.13.61.0/24","10.13.62.0/24"]
vpc_pn_confinfo_internal_subnets_names = ["PN ConfInfo - DataVault Ingress Subnet (hotfix) AZ 0","PN ConfInfo - DataVault Ingress Subnet (hotfix) AZ 1","PN ConfInfo - DataVault Ingress Subnet (hotfix) AZ 2","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (hotfix) AZ 0","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (hotfix) AZ 1","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (hotfix) AZ 2","PN ConfInfo - ConfInfo Subnet (hotfix) AZ 0","PN ConfInfo - ConfInfo Subnet (hotfix) AZ 1","PN ConfInfo - ConfInfo Subnet (hotfix) AZ 2","PN ConfInfo - PostelGW DMZ Subnet (hotfix) AZ 0","PN ConfInfo - PostelGW DMZ Subnet (hotfix) AZ 1","PN ConfInfo - PostelGW DMZ Subnet (hotfix) AZ 2","PN ConfInfo - AWS Services Subnet (hotfix) AZ 0","PN ConfInfo - AWS Services Subnet (hotfix) AZ 1","PN ConfInfo - AWS Services Subnet (hotfix) AZ 2","PN ConfInfo - To Pdf Raster Subnet (hotfix) AZ 0","PN ConfInfo - To Pdf Raster Subnet (hotfix) AZ 1","PN ConfInfo - To Pdf Raster Subnet (hotfix) AZ 2"]

vpc_pn_confinfo_dvin_subnets_cidrs = ["10.13.2.0/28","10.13.2.16/28","10.13.2.32/28"]
vpc_pn_confinfo_ecssin_subnets_cidrs = ["10.13.3.0/28","10.13.3.16/28","10.13.3.32/28"]
vpc_pn_confinfo_confinfo_egres_subnets_cidrs = ["10.13.10.0/24","10.13.11.0/24","10.13.12.0/24"]
vpc_pn_confinfo_confinfo_subnets_cidrs = ["10.13.30.0/24","10.13.31.0/24","10.13.32.0/24"]
vpc_pn_confinfo_postel_subnets_cidrs = ["10.13.40.0/24","10.13.41.0/24","10.13.42.0/24"]
vpc_pn_confinfo_to_pdfraster_subnets_cidrs = ["10.13.60.0/24","10.13.61.0/24","10.13.62.0/24"]





vpc_pn_spid_hub_name = "PN SpidHub"
vpc_pn_spid_hub_primary_cidr = "10.14.0.0/16"
vpc_pn_spid_hub_aws_services_interface_endpoints_subnets_cidr = []
vpc_endpoints_pn_spid_hub = []

vpc_pn_spid_hub_private_subnets_cidr = ["10.14.40.0/24","10.14.41.0/24","10.14.42.0/24"]
vpc_pn_spid_hub_private_subnets_names = ["PN SpidHub - Private Subnet (hotfix) AZ 0","PN SpidHub - Private Subnet (hotfix) AZ 1","PN SpidHub - Private Subnet (hotfix) AZ 2"]
vpc_pn_spid_hub_public_subnets_cidr = ["10.14.10.0/24","10.14.11.0/24","10.14.12.0/24"]
vpc_pn_spid_hub_public_subnets_names = ["PN SpidHub - Public Subnet (hotfix) AZ 0","PN SpidHub - Public Subnet (hotfix) AZ 1","PN SpidHub - Public Subnet (hotfix) AZ 2"]
vpc_pn_spid_hub_internal_subnets_cidr = []
vpc_pn_spid_hub_internal_subnets_names = []






vpc_pn_pdfraster_name = "PN PdfRaster"
vpc_pn_pdfraster_primary_cidr = "10.19.0.0/16"
vpc_pn_pdfraster_aws_services_interface_endpoints_subnets_cidr = ["10.19.50.0/24","10.19.51.0/24","10.19.52.0/24"]
vpc_endpoints_pn_pdfraster = ["sqs","logs","sns","kms","kinesis-streams","elasticloadbalancing","events","ecr.api","ecr.dkr","ssmmessages","ssm","ec2messages","ecs-agent","ecs-telemetry","ecs","secretsmanager","monitoring","xray"]

vpc_pn_pdfraster_private_subnets_cidr = []
vpc_pn_pdfraster_private_subnets_names = []
vpc_pn_pdfraster_public_subnets_cidr = ["10.19.1.0/28","10.19.1.16/28","10.19.1.32/28"]
vpc_pn_pdfraster_public_subnets_names = ["PN PdfRaster - Public Subnet (hotfix) AZ 0","PN PdfRaster - Public Subnet (hotfix) AZ 1","PN PdfRaster - Public Subnet (hotfix) AZ 2"]
vpc_pn_pdfraster_internal_subnets_cidr = ["10.19.3.0/28","10.19.3.16/28","10.19.3.32/28","10.19.30.0/24","10.19.31.0/24","10.19.32.0/24","10.19.50.0/24","10.19.51.0/24","10.19.52.0/24"]
vpc_pn_pdfraster_internal_subnets_names = ["PN PdfRaster - PdfRaster Ingress Subnet (hotfix) AZ 0","PN PdfRaster - PdfRaster Ingress Subnet (hotfix) AZ 1","PN PdfRaster - PdfRaster Ingress Subnet (hotfix) AZ 2","PN PdfRaster - PdfRaster Private Subnet (hotfix) AZ 0","PN PdfRaster - PdfRaster Private Subnet (hotfix) AZ 1","PN PdfRaster - PdfRaster Private Subnet (hotfix) AZ 2","PN PdfRaster - AWS Services Subnet (hotfix) AZ 0","PN PdfRaster - AWS Services Subnet (hotfix) AZ 1","PN PdfRaster - AWS Services Subnet (hotfix) AZ 2"]

vpc_pn_pdfraster_pdfin_subnets_cidrs = ["10.19.3.0/28","10.19.3.16/28","10.19.3.32/28"]
vpc_pn_pdfraster_pdfnet_subnets_cidrs = ["10.19.30.0/24","10.19.31.0/24","10.19.32.0/24"]


