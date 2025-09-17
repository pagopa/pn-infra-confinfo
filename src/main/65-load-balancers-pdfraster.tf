
resource "aws_security_group" "vpc_pn_pdfraster__secgrp_webapp" {
  
  name_prefix = "pn-pdfraster_vpc-webapp-secgrp"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc_pn_pdfraster.vpc_id

  ingress {
    description = "8080 from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc_pn_pdfraster_primary_cidr]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



# - ECS cluster Application load balancer 
resource "aws_lb" "pn_pdfraster_ecs_alb" {
  name_prefix        = "EcsPf-"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vpc_pn_pdfraster__secgrp_webapp.id]
  subnets            = local.PdfRaster_SubnetsIds

  enable_deletion_protection = false
  drop_invalid_header_fields = true

  idle_timeout = var.pn_pdfraster_alb_idle_timeout
  
  tags = {
    "Name": "PN PdfRaster - ECS Cluster - ALB"
    "pn-eni-related": "true",
    "pn-eni-related-groupName-regexp": base64encode("^pn-pdfraster_vpc-webapp-secgrp.*$")
  }
}
# - ECS cluster Application load balancer HTTP listener
resource "aws_lb_listener" "pn_pdfraster_ecs_alb_8080" {
  load_balancer_arn = aws_lb.pn_pdfraster_ecs_alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{ \"error\": \"404\", \"message\": \"Load balancer rule not configured\" }"
      status_code  = "404"
    }
  }
}



# - NLB Di ingresso per le invocazioni a Data Vault
resource "aws_lb" "pn_pdfraster_in_nlb" {
  name_prefix = "PdfI-"

  internal = true
  ip_address_type = "ipv4"
  load_balancer_type = "network"

  dynamic "subnet_mapping" {
    for_each = range(var.how_many_az)

    content {
      private_ipv4_address = cidrhost( local.PdfRaster_Nlb_SubnetsCidrs[subnet_mapping.key], 8)
      subnet_id = local.PdfRaster_Nlb_SubnetsIds[subnet_mapping.key]
    }
  }

  tags = {
    "Name": "PN PdfRaster - Ingress - NLB",
    "pn-eni-related": "true",
    "pn-eni-related-description-regexp": base64encode("^ELB net/PdfI-.*$")
  }
}
# - ServiceEndpoint ingresso per le invocazioni a pn-pdfraster
resource "aws_vpc_endpoint_service" "pn_pdfraster_in_endpoint_svc" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.pn_pdfraster_in_nlb.arn]
  allowed_principals         = ["arn:aws:iam::${var.pn_confinfo_aws_account_id}:root"]

  tags = {
    "Name": "PN PdfRaster - SVC endpoint"
  }
}
# - DataVault NLB listener for HTTP
resource "aws_lb_listener" "pn_pdfraster_in_nlb_http_to_alb_http" {
  load_balancer_arn = aws_lb.pn_pdfraster_in_nlb.arn
  protocol = "TCP"
  port     = 8080

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pn_pdfraster_in_nlb_http_to_alb_http.arn
  }
}
# - PdfRaster NLB target group for HTTP
resource "aws_lb_target_group" "pn_pdfraster_in_nlb_http_to_alb_http" {
  name_prefix = "PdfI-"
  vpc_id      = module.vpc_pn_pdfraster.vpc_id

  port        = 8080
  protocol    = "TCP"
  target_type = "alb"
  
  depends_on = [
    aws_lb.pn_pdfraster_in_nlb,
    aws_lb.pn_pdfraster_ecs_alb
  ]

  tags = {
    "Description": "PN PdfRaster - NLB to ALB - Target Group"
  }

  health_check {
    enabled = true
    matcher = "200-499"
  }
}
resource "aws_lb_target_group_attachment" "pn_pdfraster_in_nlb_http_to_alb_http" {
  target_group_arn  = aws_lb_target_group.pn_pdfraster_in_nlb_http_to_alb_http.arn
  port              = 8080

  target_id         = aws_lb.pn_pdfraster_ecs_alb.arn
}


resource "aws_network_acl" "call_8080_do_not_receive_pdfraster" {
  vpc_id = module.vpc_pn_pdfraster.vpc_id

  dynamic "egress" {
    for_each = local.PdfRaster_SubnetsCidrs

    content {
      protocol   = "tcp"
      rule_no    = 1000 + 100 * egress.key
      action     = "allow"
      cidr_block = egress.value
      from_port  = 8080
      to_port    = 8080
    }
  }

  dynamic "ingress" {
    for_each = local.PdfRaster_SubnetsCidrs

    content {
      protocol   = "tcp"
      rule_no    = 1000 + 100 * ingress.key
      action     = "allow"
      cidr_block = ingress.value
      from_port  = 1024
      to_port    = 8079
    }
  }

  dynamic "ingress" {
    for_each = local.PdfRaster_SubnetsCidrs

    content {
      protocol   = "tcp"
      rule_no    = 2000 + 100 * ingress.key
      action     = "allow"
      cidr_block = ingress.value
      from_port  = 8081
      to_port    = 65535
    }
  }

  tags = {
    Name = "Outbound 8080 to ALB not inbound"
  }
}

resource "aws_network_acl_association" "nlb_pdf" {
  count = length( local.PdfRaster_Nlb_SubnetsIds )

  network_acl_id = aws_network_acl.call_8080_do_not_receive_pdfraster.id
  subnet_id      = local.PdfRaster_Nlb_SubnetsIds[ count.index ]
}