locals {

  ConfInfo_SubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          module.vpc_pn_confinfo.intra_subnets[idx] 
            if contains( var.vpc_pn_confinfo_confinfo_subnets_cidrs, cidr)
    ]
  
  ConfInfo_SubnetsCidrs = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_confinfo_confinfo_subnets_cidrs, cidr)
    ]
  

  ConfInfo_EgressSubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.private_subnets_cidr_blocks:
          module.vpc_pn_confinfo.private_subnets[idx] 
            if contains( var.vpc_pn_confinfo_confinfo_egres_subnets_cidrs, cidr)
    ]
  
  ConfInfo_EgressSubnetsCidrs = [
      for idx, cidr in module.vpc_pn_confinfo.private_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_confinfo_confinfo_egres_subnets_cidrs, cidr)
    ]
  

  ConfInfo_NlbDv_SubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          module.vpc_pn_confinfo.intra_subnets[idx] 
            if contains( var.vpc_pn_confinfo_dvin_subnets_cidrs, cidr)
    ]
  
  ConfInfo_NlbDv_SubnetsCidrs = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_confinfo_dvin_subnets_cidrs, cidr)
    ]
  

  ConfInfo_NlbEcss_SubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          module.vpc_pn_confinfo.intra_subnets[idx] 
            if contains( var.vpc_pn_confinfo_ecssin_subnets_cidrs, cidr)
    ]
  
  ConfInfo_NlbEcss_SubnetsCidrs = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_confinfo_ecssin_subnets_cidrs, cidr)
    ]
  
  ConfInfo_NlbPostel_SubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          module.vpc_pn_confinfo.intra_subnets[idx] 
            if contains( var.vpc_pn_confinfo_postel_subnets_cidrs, cidr)
    ]
  
  ConfInfo_NlbPostel_SubnetsCidrs = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_confinfo_postel_subnets_cidrs, cidr)
    ]

  Confinfo_ToPdfRaster_SubnetsIds = [
      for idx, cidr in module.vpc_pn_confinfo.intra_subnets_cidr_blocks:
          module.vpc_pn_confinfo.intra_subnets[idx] 
            if contains( var.vpc_pn_confinfo_to_pdfraster_subnets_cidrs, cidr)
    ]
  
  SpidHub_FrontEndSubnetsIds = [
      for idx, cidr in module.vpc_pn_spid_hub.public_subnets_cidr_blocks:
          module.vpc_pn_spid_hub.public_subnets[idx] 
            if contains( var.vpc_pn_spid_hub_public_subnets_cidr, cidr)
    ]
  
  SpidHub_FrontEndSubnetsCidrs = [
      for idx, cidr in module.vpc_pn_spid_hub.public_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_spid_hub_public_subnets_cidr, cidr)
    ]
  

  SpidHub_BackEndSubnetsIds = [
      for idx, cidr in module.vpc_pn_spid_hub.private_subnets_cidr_blocks:
          module.vpc_pn_spid_hub.private_subnets[idx] 
            if contains( var.vpc_pn_spid_hub_private_subnets_cidr, cidr)
    ]
  
  SpidHub_BackEndSubnetsCidrs = [
      for idx, cidr in module.vpc_pn_spid_hub.private_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_spid_hub_private_subnets_cidr, cidr)
    ]
  

  SpidHub_InternalNlbIps = [
      for idx, cidr in local.SpidHub_BackEndSubnetsCidrs:
        cidrhost( cidr, 220 )
    ]


  PdfRaster_SubnetsIds = [
      for idx, cidr in module.vpc_pn_pdfraster.intra_subnets_cidr_blocks:
          module.vpc_pn_pdfraster.intra_subnets[idx] 
            if contains( var.vpc_pn_pdfraster_pdfnet_subnets_cidrs, cidr)
    ]
  
  PdfRaster_SubnetsCidrs = [
      for idx, cidr in module.vpc_pn_pdfraster.intra_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_pdfraster_pdfnet_subnets_cidrs, cidr)
    ]
  

  PdfRaster_Nlb_SubnetsIds = [
      for idx, cidr in module.vpc_pn_pdfraster.intra_subnets_cidr_blocks:
          module.vpc_pn_pdfraster.intra_subnets[idx] 
            if contains( var.vpc_pn_pdfraster_pdfin_subnets_cidrs, cidr)
    ]
  
  PdfRaster_Nlb_SubnetsCidrs = [
      for idx, cidr in module.vpc_pn_pdfraster.intra_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_pdfraster_pdfin_subnets_cidrs, cidr)
    ]

  iam_managed_policy_attachments = {
    for tuple in flatten([
      for role_name, config in var.iam_ext_roles_config : [
        for policy_name in config.managed_policies : {
          key         = "${role_name}.${policy_name}"
          role_name   = role_name
          policy_name = policy_name
        }
      ]
    ]) : tuple.key => {
      role_name   = tuple.role_name
      policy_name = tuple.policy_name
    }
  }

  iam_inline_policy_attachments = {
    for tuple in flatten([
      for role_name, config in var.iam_ext_roles_config : [
        for inline_policy in lookup(config, "inline_policies", []) : {
          key         = "${role_name}.${inline_policy.name}"
          role_name   = role_name
          policy_name = inline_policy.name
          policy_file = "./policies/${inline_policy.name}.json"
        }
      ]
    ]) : tuple.key => {
      role_name   = tuple.role_name
      policy_name = tuple.policy_name
      policy_file = tuple.policy_file
    }
  }
  
}
