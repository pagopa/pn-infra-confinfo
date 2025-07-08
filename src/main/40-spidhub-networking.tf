  
module "vpc_pn_spid_hub" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = var.vpc_pn_spid_hub_name
  cidr = var.vpc_pn_spid_hub_primary_cidr

  azs                 = local.azs_names
  private_subnets     = var.vpc_pn_spid_hub_private_subnets_cidr
  public_subnets      = var.vpc_pn_spid_hub_public_subnets_cidr
  intra_subnets       = var.vpc_pn_spid_hub_internal_subnets_cidr

  private_subnet_names     = var.vpc_pn_spid_hub_private_subnets_names
  public_subnet_names      = var.vpc_pn_spid_hub_public_subnets_names
  intra_subnet_names       = var.vpc_pn_spid_hub_internal_subnets_names

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  enable_vpn_gateway = false

  enable_dhcp_options              = false

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
  map_public_ip_on_launch       = true

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60

  tags = { 
    "Code" = "pn-spid_hub",
    "Terraform" = "true",
    "Environment" = var.environment
  }
}

resource "aws_security_group" "vpc_pn_spid_hub__secgrp_tls" {
  
  name_prefix = "pn-spid_hub_vpc-tls-secgrp"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc_pn_spid_hub.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_pn_spid_hub_primary_cidr]
  }

}

module "vpc_endpoints_pn_spid_hub" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.17.0"

  vpc_id             = module.vpc_pn_spid_hub.vpc_id
  security_group_ids = [ aws_security_group.vpc_pn_spid_hub__secgrp_tls.id ]
  subnet_ids         = [ 
        for cidr in var.vpc_pn_spid_hub_aws_services_interface_endpoints_subnets_cidr:
          module.vpc_pn_spid_hub.intra_subnets[
              index( module.vpc_pn_spid_hub.intra_subnets_cidr_blocks, cidr )
            ]
      ]
  
  endpoints = merge(
    {
      for svc_name in var.vpc_endpoints_pn_spid_hub:
        svc_name => {
          service             = svc_name
          private_dns_enabled = true  
          tags                = { Name = "AWS Endpoint ${svc_name} - pn-spid_hub - ${var.environment}"}
        }
    },
    {
      dynamodb = {
        service         = "dynamodb"
        service_type    = "Gateway"
        route_table_ids = flatten([
          module.vpc_pn_spid_hub.intra_route_table_ids, 
          module.vpc_pn_spid_hub.private_route_table_ids 
        ])
        tags                = { Name = "AWS Endpoint dynamodb - pn-spid_hub - ${var.environment}"}
      },
      s3 = {
        service         = "s3"
        service_type    = "Gateway"
        route_table_ids = flatten([
          module.vpc_pn_spid_hub.intra_route_table_ids, 
          module.vpc_pn_spid_hub.private_route_table_ids 
        ])
        tags                = { Name = "AWS Endpoint s3 - pn-spid_hub - ${var.environment}"}
      },
    }
  )
}

