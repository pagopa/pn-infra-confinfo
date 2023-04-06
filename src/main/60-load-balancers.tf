
resource "aws_security_group" "vpc_pn_confinfo__secgrp_webapp" {
  
  name_prefix = "pn-confinfo_vpc-webapp-secgrp"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc_pn_confinfo.vpc_id

  ingress {
    description = "8080 from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_pn_confinfo_primary_cidr]
  }

}


resource "aws_lb" "pn_confinfo_ecs_alb" {
  name_prefix        = "EcsA-"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vpc_pn_confinfo__secgrp_webapp.id]
  subnets            = local.ConfInfo_SubnetsIds

  enable_deletion_protection = false

  tags = {
    "Name": "PN ConfInfo - ECS Cluster - ALB"
  }
}


resource "aws_lb" "pn_confinfo_dvin_nlb" {
  name_prefix = "DvI-"

  internal = true
  ip_address_type = "ipv4"
  load_balancer_type = "network"

  subnet_mapping {
    private_ipv4_address = cidrhost( local.ConfInfo_NlbDv_SubnetsCidrs[0], 8)
    subnet_id = local.ConfInfo_NlbDv_SubnetsIds[0]
  }

  subnet_mapping {
    private_ipv4_address = cidrhost( local.ConfInfo_NlbDv_SubnetsCidrs[1], 8)
    subnet_id = local.ConfInfo_NlbDv_SubnetsIds[1]
  }
  
  subnet_mapping {
    private_ipv4_address = cidrhost( local.ConfInfo_NlbDv_SubnetsCidrs[2], 8)
    subnet_id = local.ConfInfo_NlbDv_SubnetsIds[2]
  }

  tags = {
    "Name": "PN ConfInfo - DataVault Ingress - NLB"
  }
}
resource "aws_vpc_endpoint_service" "pn_confinfo_dvin_endpoint_svc" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.pn_confinfo_dvin_nlb.arn]
  allowed_principals         = ["arn:aws:iam::${var.pn_core_aws_account_id}:root"]

  tags = {
    "Name": "PN ConfInfo - DataVault - SVC endpoint"
  }
}


resource "aws_lb" "pn_confinfo_ecssin_nlb" {
  name_prefix = "EcssI-"

  internal = true
  ip_address_type = "ipv4"
  load_balancer_type = "network"

  subnet_mapping {
    private_ipv4_address = cidrhost( local.ConfInfo_NlbEcss_SubnetsCidrs[0], 8)
    subnet_id = local.ConfInfo_NlbEcss_SubnetsIds[0]
  }

  subnet_mapping {
    private_ipv4_address = cidrhost( local.ConfInfo_NlbEcss_SubnetsCidrs[1], 8)
    subnet_id = local.ConfInfo_NlbEcss_SubnetsIds[1]
  }
  
  subnet_mapping {
    private_ipv4_address = cidrhost( local.ConfInfo_NlbEcss_SubnetsCidrs[2], 8)
    subnet_id = local.ConfInfo_NlbEcss_SubnetsIds[2]
  }

  tags = {
    "Name": "PN ConfInfo - ExternalChannel and SafeStorage Ingress - NLB"
  }
}
resource "aws_vpc_endpoint_service" "pn_confinfo_ecssin_endpoint_svc" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.pn_confinfo_ecssin_nlb.arn]
  allowed_principals         = ["arn:aws:iam::${var.pn_core_aws_account_id}:root"]

  tags = {
    "Name": "PN ConfInfo - SafeStorage and ExternalChannel - SVC endpoint"
  }
}

