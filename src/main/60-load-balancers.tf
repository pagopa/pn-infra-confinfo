
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
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



# - ECS cluster Application load balancer 
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
# - ECS cluster Application load balancer HTTP listener
resource "aws_lb_listener" "pn_confinfo_ecs_alb_8080" {
  load_balancer_arn = aws_lb.pn_confinfo_ecs_alb.arn
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
resource "aws_lb" "pn_confinfo_dvin_nlb" {
  name_prefix = "DvI-"

  internal = true
  ip_address_type = "ipv4"
  load_balancer_type = "network"


  dynamic "subnet_mapping" {
    for_each = range(var.how_many_az)

    content {
      private_ipv4_address = cidrhost( local.ConfInfo_NlbDv_SubnetsCidrs[subnet_mapping.key], 8)
      subnet_id = local.ConfInfo_NlbDv_SubnetsIds[subnet_mapping.key]
    }
  }

  tags = {
    "Name": "PN ConfInfo - DataVault Ingress - NLB"
  }
}
# - ServiceEndpoint ingresso per le invocazioni a Data Vault
resource "aws_vpc_endpoint_service" "pn_confinfo_dvin_endpoint_svc" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.pn_confinfo_dvin_nlb.arn]
  allowed_principals         = ["arn:aws:iam::${var.pn_core_aws_account_id}:root"]

  tags = {
    "Name": "PN ConfInfo - DataVault - SVC endpoint"
  }
}
# - DataVault NLB listener for HTTP
resource "aws_lb_listener" "pn_confinfo_dvin_nlb_http_to_alb_http" {
  load_balancer_arn = aws_lb.pn_confinfo_dvin_nlb.arn
  protocol = "TCP"
  port     = 8080

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pn_confinfo_dvin_nlb_http_to_alb_http.arn
  }
}
# - DataVault NLB target group for HTTP
resource "aws_lb_target_group" "pn_confinfo_dvin_nlb_http_to_alb_http" {
  name_prefix = "DvI-"
  vpc_id      = module.vpc_pn_confinfo.vpc_id

  port        = 8080
  protocol    = "TCP"
  target_type = "alb"
  
  depends_on = [
    aws_lb.pn_confinfo_dvin_nlb,
    aws_lb.pn_confinfo_ecs_alb
  ]

  tags = {
    "Description": "PN ConfInfo - DataVault NLB to ALB - Target Group"
  }

  health_check {
    enabled = true
    matcher = "200-499"
  }
}
resource "aws_lb_target_group_attachment" "pn_confinfo_dvin_nlb_http_to_alb_http" {
  target_group_arn  = aws_lb_target_group.pn_confinfo_dvin_nlb_http_to_alb_http.arn
  port              = 8080

  target_id         = aws_lb.pn_confinfo_ecs_alb.arn
}



# - NLB Di ingresso per le invocazioni a ExternalChannel e SafeStorage
resource "aws_lb" "pn_confinfo_ecssin_nlb" {
  name_prefix = "EcssI-"

  internal = true
  ip_address_type = "ipv4"
  load_balancer_type = "network"

  dynamic "subnet_mapping" {
    for_each = range(var.how_many_az)

    content {
      private_ipv4_address = cidrhost( local.ConfInfo_NlbEcss_SubnetsCidrs[subnet_mapping.key], 8)
      subnet_id = local.ConfInfo_NlbEcss_SubnetsIds[subnet_mapping.key]
    }
  }

  tags = {
    "Name": "PN ConfInfo - ExternalChannel and SafeStorage Ingress - NLB"
  }
}
# - ServiceEndpoint ingresso per le invocazioni a ExternalChannel e SafeStorage
resource "aws_vpc_endpoint_service" "pn_confinfo_ecssin_endpoint_svc" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.pn_confinfo_ecssin_nlb.arn]
  allowed_principals         = ["arn:aws:iam::${var.pn_core_aws_account_id}:root"]

  tags = {
    "Name": "PN ConfInfo - SafeStorage and ExternalChannel - SVC endpoint"
  }
}
# - ExternalChannel e SafeStorage NLB listener for HTTP
resource "aws_lb_listener" "pn_confinfo_ecssin_nlb_http_to_alb_http" {
  load_balancer_arn = aws_lb.pn_confinfo_ecssin_nlb.arn
  protocol = "TCP"
  port     = 8080

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pn_confinfo_ecssin_nlb_http_to_alb_http.arn
  }
}
# - ExternalChannel e SafeStorage NLB target group for HTTP
resource "aws_lb_target_group" "pn_confinfo_ecssin_nlb_http_to_alb_http" {
  name_prefix = "EcssI-"
  vpc_id      = module.vpc_pn_confinfo.vpc_id

  port        = 8080
  protocol    = "TCP"
  target_type = "alb"
  
  depends_on = [
    aws_lb.pn_confinfo_ecssin_nlb,
    aws_lb.pn_confinfo_ecs_alb
  ]

  tags = {
    "Description": "PN ConfInfo - ExternalChannel and SafeStorage NLB to ALB - Target Group"
  }

  health_check {
    enabled = true
    matcher = "200-499"
  }
}
resource "aws_lb_target_group_attachment" "pn_confinfo_ecssin_nlb_http_to_alb_http" {
  target_group_arn  = aws_lb_target_group.pn_confinfo_ecssin_nlb_http_to_alb_http.arn
  port              = 8080

  target_id         = aws_lb.pn_confinfo_ecs_alb.arn
}




# - NLB Di ingresso per le invocazioni da consolidatore
resource "aws_lb" "pn_confinfo_postel_nlb" {
  name_prefix = "PtI-"

  internal = true
  ip_address_type = "ipv4"
  load_balancer_type = "network"

  dynamic "subnet_mapping" {
    for_each = range(var.how_many_az)

    content {
      private_ipv4_address = cidrhost( local.ConfInfo_NlbPostel_SubnetsCidrs[subnet_mapping.key], 8)
      subnet_id = local.ConfInfo_NlbPostel_SubnetsIds[subnet_mapping.key]
    }
  }

  tags = {
    "Name": "PN Confinfo - Postel Ingress - NLB"
  }
}
# - ServiceEndpoint ingresso per le invocazioni a pn-external-channel da parte del consolidatore
resource "aws_vpc_endpoint_service" "pn_confinfo_postel_endpoint_svc" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.pn_confinfo_postel_nlb.arn]
  allowed_principals         = ["arn:aws:iam::${var.pn_postel_aws_account_id}:root"]

  tags = {
    "Name": "PN Confinfo - Postel - SVC endpoint"
  }
}
# - Postel NLB listener for HTTP
resource "aws_lb_listener" "pn_confinfo_postel_nlb_http_to_alb_http" {
  load_balancer_arn = aws_lb.pn_confinfo_postel_nlb.arn
  protocol = "TCP"
  port     = 8080

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pn_confinfo_postel_nlb_http_to_alb_http.arn
  }
}
# - Postel NLB target group for HTTP
resource "aws_lb_target_group" "pn_confinfo_postel_nlb_http_to_alb_http" {
  name_prefix = "PtI-"
  vpc_id      = module.vpc_pn_confinfo.vpc_id

  port        = 8080
  protocol    = "TCP"
  target_type = "alb"
  
  depends_on = [
    aws_lb.pn_confinfo_postel_nlb,
    aws_lb.pn_confinfo_ecs_alb
  ]

  tags = {
    "Description": "PN Confinfo - Postel NLB to ALB - Target Group"
  }

  health_check {
    enabled = true
    matcher = "200-499"
  }
}
# - Postel NLB target group for HTTP attachmet
resource "aws_lb_target_group_attachment" "pn_confinfo_postel_nlb_http_to_alb_http" {
  target_group_arn  = aws_lb_target_group.pn_confinfo_postel_nlb_http_to_alb_http.arn
  port              = 8080

  target_id         = aws_lb.pn_confinfo_ecs_alb.arn
}

# - Postel NLB listener for HTTPS
resource "aws_lb_listener" "pn_confinfo_postel_nlb_https_to_nlb_http" {
  load_balancer_arn = aws_lb.pn_confinfo_postel_nlb.arn
  protocol = "TLS"
  port     = 8443
  
  alpn_policy = "None"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = module.acm_api["api.pt"].acm_certificate_arn
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pn_confinfo_postel_nlb_https_to_nlb_http.arn
  }
}
# - Postel NLB target group for HTTPS
resource "aws_lb_target_group" "pn_confinfo_postel_nlb_https_to_nlb_http" {
  name_prefix = "PtT-"
  vpc_id      = module.vpc_pn_confinfo.vpc_id

  port        = 8080
  protocol    = "TCP"
  target_type = "ip"
  
  tags = {
    "Description": "PN Confinfo - Postel NLB TLS termination - Target Group"
  }

  health_check {
    enabled = true
    path = "/"
    matcher = "200-499"
  }
}
resource "aws_lb_target_group_attachment" "pn_confinfo_postel_nlb_https_to_nlb_http" {
  count = var.how_many_az

  target_group_arn  = aws_lb_target_group.pn_confinfo_postel_nlb_https_to_nlb_http.arn
  port              = 8080

  target_id         = cidrhost( local.ConfInfo_NlbPostel_SubnetsCidrs[count.index], 8)
  availability_zone = local.azs_names[count.index]
}






resource "aws_network_acl" "call_8080_do_not_receive" {
  vpc_id = module.vpc_pn_confinfo.vpc_id

  dynamic "egress" {
    for_each = local.ConfInfo_SubnetsCidrs

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
    for_each = local.ConfInfo_SubnetsCidrs

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
    for_each = local.ConfInfo_SubnetsCidrs

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

resource "aws_network_acl_association" "nlb_dv" {
  count = length( local.ConfInfo_NlbDv_SubnetsIds )

  network_acl_id = aws_network_acl.call_8080_do_not_receive.id
  subnet_id      = local.ConfInfo_NlbDv_SubnetsIds[ count.index ]
}

resource "aws_network_acl_association" "nlb_ecss" {
  count = length( local.ConfInfo_NlbEcss_SubnetsIds )

  network_acl_id = aws_network_acl.call_8080_do_not_receive.id
  subnet_id      = local.ConfInfo_NlbEcss_SubnetsIds[ count.index ]
}

resource "aws_network_acl_association" "nlb_postel" {
  count = length( local.ConfInfo_NlbPostel_SubnetsIds )

  network_acl_id = aws_network_acl.call_8080_do_not_receive.id
  subnet_id      = local.ConfInfo_NlbPostel_SubnetsIds[ count.index ]
}
