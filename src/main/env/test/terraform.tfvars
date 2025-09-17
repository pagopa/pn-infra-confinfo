
environment = "test"
how_many_az = 3
dns_zone = "spid.test.notifichedigitali.it"
api_domains = ["api.pt"]
cdn_domains = []
apigw_custom_domains = []
  
pn_core_aws_account_id = "151559006927"
pn_confinfo_aws_account_id = "771887334808"
pn_confinfo_to_postel_vpcse = "com.amazonaws.vpce.eu-south-1.vpce-svc-0a03e3680c586118c"
pn_cost_anomaly_detection_email = "pn-irt-team@pagopa.it"
pn_cost_anomaly_detection_threshold = "10"
pn_pdfraster_alb_idle_timeout = "60"
pn_postel_aws_account_id = "554102482368"


vpc_pn_confinfo_name = "PN ConfInfo"
vpc_pn_confinfo_primary_cidr = "10.4.0.0/16"
vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr = ["10.4.50.0/24","10.4.51.0/24","10.4.52.0/24"]
vpc_endpoints_pn_confinfo = ["sqs","logs","sns","kms","kinesis-streams","elasticloadbalancing","events","ecr.api","ecr.dkr","ssmmessages","ssm","ec2messages","ecs-agent","ecs-telemetry","ecs","secretsmanager","monitoring","xray"]

vpc_pn_confinfo_private_subnets_cidr = ["10.4.10.0/24","10.4.11.0/24","10.4.12.0/24"]
vpc_pn_confinfo_private_subnets_names = ["PN ConfInfo - ConfInfo Egress Subnet (test) AZ 0","PN ConfInfo - ConfInfo Egress Subnet (test) AZ 1","PN ConfInfo - ConfInfo Egress Subnet (test) AZ 2"]
vpc_pn_confinfo_public_subnets_cidr = ["10.4.1.0/28","10.4.1.16/28","10.4.1.32/28"]
vpc_pn_confinfo_public_subnets_names = ["PN ConfInfo - Public Subnet (test) AZ 0","PN ConfInfo - Public Subnet (test) AZ 1","PN ConfInfo - Public Subnet (test) AZ 2"]
vpc_pn_confinfo_internal_subnets_cidr = ["10.4.2.0/28","10.4.2.16/28","10.4.2.32/28","10.4.3.0/28","10.4.3.16/28","10.4.3.32/28","10.4.30.0/24","10.4.31.0/24","10.4.32.0/24","10.4.40.0/24","10.4.41.0/24","10.4.42.0/24","10.4.50.0/24","10.4.51.0/24","10.4.52.0/24","10.4.60.0/24","10.4.61.0/24","10.4.62.0/24"]
vpc_pn_confinfo_internal_subnets_names = ["PN ConfInfo - DataVault Ingress Subnet (test) AZ 0","PN ConfInfo - DataVault Ingress Subnet (test) AZ 1","PN ConfInfo - DataVault Ingress Subnet (test) AZ 2","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (test) AZ 0","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (test) AZ 1","PN ConfInfo - ExternalChannels SafeStorage Ingress Subnet (test) AZ 2","PN ConfInfo - ConfInfo Subnet (test) AZ 0","PN ConfInfo - ConfInfo Subnet (test) AZ 1","PN ConfInfo - ConfInfo Subnet (test) AZ 2","PN ConfInfo - PostelGW DMZ Subnet (test) AZ 0","PN ConfInfo - PostelGW DMZ Subnet (test) AZ 1","PN ConfInfo - PostelGW DMZ Subnet (test) AZ 2","PN ConfInfo - AWS Services Subnet (test) AZ 0","PN ConfInfo - AWS Services Subnet (test) AZ 1","PN ConfInfo - AWS Services Subnet (test) AZ 2","PN ConfInfo - To Pdf Raster Subnet (test) AZ 0","PN ConfInfo - To Pdf Raster Subnet (test) AZ 1","PN ConfInfo - To Pdf Raster Subnet (test) AZ 2"]

vpc_pn_confinfo_dvin_subnets_cidrs = ["10.4.2.0/28","10.4.2.16/28","10.4.2.32/28"]
vpc_pn_confinfo_ecssin_subnets_cidrs = ["10.4.3.0/28","10.4.3.16/28","10.4.3.32/28"]
vpc_pn_confinfo_confinfo_egres_subnets_cidrs = ["10.4.10.0/24","10.4.11.0/24","10.4.12.0/24"]
vpc_pn_confinfo_confinfo_subnets_cidrs = ["10.4.30.0/24","10.4.31.0/24","10.4.32.0/24"]
vpc_pn_confinfo_postel_subnets_cidrs = ["10.4.40.0/24","10.4.41.0/24","10.4.42.0/24"]
vpc_pn_confinfo_to_pdfraster_subnets_cidrs = ["10.4.60.0/24","10.4.61.0/24","10.4.62.0/24"]





vpc_pn_spid_hub_name = "PN SpidHub"
vpc_pn_spid_hub_primary_cidr = "10.5.0.0/16"
vpc_pn_spid_hub_aws_services_interface_endpoints_subnets_cidr = []
vpc_endpoints_pn_spid_hub = []

vpc_pn_spid_hub_private_subnets_cidr = ["10.5.40.0/24","10.5.41.0/24","10.5.42.0/24"]
vpc_pn_spid_hub_private_subnets_names = ["PN SpidHub - Private Subnet (test) AZ 0","PN SpidHub - Private Subnet (test) AZ 1","PN SpidHub - Private Subnet (test) AZ 2"]
vpc_pn_spid_hub_public_subnets_cidr = ["10.5.10.0/24","10.5.11.0/24","10.5.12.0/24"]
vpc_pn_spid_hub_public_subnets_names = ["PN SpidHub - Public Subnet (test) AZ 0","PN SpidHub - Public Subnet (test) AZ 1","PN SpidHub - Public Subnet (test) AZ 2"]
vpc_pn_spid_hub_internal_subnets_cidr = []
vpc_pn_spid_hub_internal_subnets_names = []






vpc_pn_pdfraster_name = "PN PdfRaster"
vpc_pn_pdfraster_primary_cidr = "10.16.0.0/16"
vpc_pn_pdfraster_aws_services_interface_endpoints_subnets_cidr = ["10.16.50.0/24","10.16.51.0/24","10.16.52.0/24"]
vpc_endpoints_pn_pdfraster = ["sqs","logs","sns","kms","kinesis-streams","elasticloadbalancing","events","ecr.api","ecr.dkr","ssmmessages","ssm","ec2messages","ecs-agent","ecs-telemetry","ecs","secretsmanager","monitoring","xray"]

vpc_pn_pdfraster_private_subnets_cidr = []
vpc_pn_pdfraster_private_subnets_names = []
vpc_pn_pdfraster_public_subnets_cidr = ["10.16.1.0/28","10.16.1.16/28","10.16.1.32/28"]
vpc_pn_pdfraster_public_subnets_names = ["PN PdfRaster - Public Subnet (test) AZ 0","PN PdfRaster - Public Subnet (test) AZ 1","PN PdfRaster - Public Subnet (test) AZ 2"]
vpc_pn_pdfraster_internal_subnets_cidr = ["10.16.3.0/28","10.16.3.16/28","10.16.3.32/28","10.16.30.0/24","10.16.31.0/24","10.16.32.0/24","10.16.50.0/24","10.16.51.0/24","10.16.52.0/24"]
vpc_pn_pdfraster_internal_subnets_names = ["PN PdfRaster - PdfRaster Ingress Subnet (test) AZ 0","PN PdfRaster - PdfRaster Ingress Subnet (test) AZ 1","PN PdfRaster - PdfRaster Ingress Subnet (test) AZ 2","PN PdfRaster - PdfRaster Private Subnet (test) AZ 0","PN PdfRaster - PdfRaster Private Subnet (test) AZ 1","PN PdfRaster - PdfRaster Private Subnet (test) AZ 2","PN PdfRaster - AWS Services Subnet (test) AZ 0","PN PdfRaster - AWS Services Subnet (test) AZ 1","PN PdfRaster - AWS Services Subnet (test) AZ 2"]

vpc_pn_pdfraster_pdfin_subnets_cidrs = ["10.16.3.0/28","10.16.3.16/28","10.16.3.32/28"]
vpc_pn_pdfraster_pdfnet_subnets_cidrs = ["10.16.30.0/24","10.16.31.0/24","10.16.32.0/24"]


