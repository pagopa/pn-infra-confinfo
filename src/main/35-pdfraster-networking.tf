  
module "vpc_pn_pdfraster" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0"

  name = var.vpc_pn_pdfraster_name
  cidr = var.vpc_pn_pdfraster_primary_cidr

  azs                 = local.azs_names
  private_subnets     = var.vpc_pn_pdfraster_private_subnets_cidr
  public_subnets      = var.vpc_pn_pdfraster_public_subnets_cidr
  intra_subnets       = var.vpc_pn_pdfraster_internal_subnets_cidr

  private_subnet_names     = var.vpc_pn_pdfraster_private_subnets_names
  public_subnet_names      = var.vpc_pn_pdfraster_public_subnets_names
  intra_subnet_names       = var.vpc_pn_pdfraster_internal_subnets_names

  create_database_subnet_group = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  enable_dhcp_options              = false

  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false
  map_public_ip_on_launch       = false

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = false
  create_flow_log_cloudwatch_log_group = false
  create_flow_log_cloudwatch_iam_role  = false
  flow_log_max_aggregation_interval    = 60

  tags = { 
    "Code" = "pn-pdfraster",
    "Terraform" = "true",
    "Environment" = var.environment
  }
}

resource "aws_security_group" "vpc_pn_pdfraster__secgrp_tls" {
  
  name_prefix = "pn-pdfraster_vpc-tls-secgrp"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc_pn_pdfraster.vpc_id

  tags = {
    "pn-eni-related": "true",
    "pn-eni-related-groupName-regexp": base64encode("^pn-pdfraster_vpc-tls-.*$")
  }
  
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_pn_pdfraster_primary_cidr]
  }

}

module "vpc_endpoints_pn_pdfraster" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.17.0"

  vpc_id             = module.vpc_pn_pdfraster.vpc_id
  security_group_ids = [ aws_security_group.vpc_pn_pdfraster__secgrp_tls.id ]
  subnet_ids         = [ 
        for cidr in var.vpc_pn_pdfraster_aws_services_interface_endpoints_subnets_cidr:
          module.vpc_pn_pdfraster.intra_subnets[
              index( module.vpc_pn_pdfraster.intra_subnets_cidr_blocks, cidr )
            ]
      ]
  
  endpoints = merge(
    {
      for svc_name in var.vpc_endpoints_pn_pdfraster:
        svc_name => {
          service             = svc_name
          private_dns_enabled = true  
          tags                = { Name = "AWS Endpoint ${svc_name} - pn-pdfraster - ${var.environment}"}
        }
    },
    {
      dynamodb = {
        service         = "dynamodb"
        service_type    = "Gateway"
        route_table_ids = flatten([
          module.vpc_pn_pdfraster.intra_route_table_ids, 
          module.vpc_pn_pdfraster.private_route_table_ids 
        ])
        tags                = { Name = "AWS Endpoint dynamodb - pn-pdfraster - ${var.environment}"}
      },
      s3 = {
        service         = "s3"
        service_type    = "Gateway"
        route_table_ids = flatten([
          module.vpc_pn_pdfraster.intra_route_table_ids, 
          module.vpc_pn_pdfraster.private_route_table_ids 
        ])
        tags                = { Name = "AWS Endpoint s3 - pn-pdfraster - ${var.environment}"}
      },
    }
  )
}


resource "aws_security_group" "vpc_pn_confinfo__secgrp_topdfraster" {
  
  name_prefix = "pn-confinfo_vpc-topdfraster-secgrp"
  description = "Allow HTTP_8080 inbound traffic"
  vpc_id      = module.vpc_pn_confinfo.vpc_id

  ingress {
    description = "8080 from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_pn_confinfo_primary_cidr]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# PRIVATE LINK ENDPOINTS TO PdfRaster
resource "aws_vpc_endpoint" "to_pdfraster" {
  vpc_id            = module.vpc_pn_confinfo.vpc_id
  service_name      = aws_vpc_endpoint_service.pn_pdfraster_in_endpoint_svc.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [ aws_security_group.vpc_pn_confinfo__secgrp_topdfraster.id ]

  subnet_ids          = local.Confinfo_ToPdfRaster_SubnetsIds
  private_dns_enabled = false

  tags                = { 
    Name = "Endpoint to pn-pdfraster"
    "pn-eni-related" = "true"
    "pn-eni-related-groupName-regexp" = base64encode("^pn-confinfo_vpc-topdfraster-.*$")
  }
}