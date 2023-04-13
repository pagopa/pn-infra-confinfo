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
  



  HubSpid_FrontEndSubnetsIds = [
      for idx, cidr in module.vpc_pn_spid_hub.public_subnets_cidr_blocks:
          module.vpc_pn_spid_hub.public_subnets[idx] 
            if contains( var.vpc_pn_spid_hub_public_subnets_cidr, cidr)
    ]
  
  HubSpid_FrontEndSubnetsCidrs = [
      for idx, cidr in module.vpc_pn_spid_hub.public_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_spid_hub_public_subnets_cidr, cidr)
    ]
  

  HubSpid_BackEndSubnetsIds = [
      for idx, cidr in module.vpc_pn_spid_hub.private_subnets_cidr_blocks:
          module.vpc_pn_spid_hub.private_subnets[idx] 
            if contains( var.vpc_pn_spid_hub_private_subnets_cidr, cidr)
    ]
  
  HubSpid_BackEndSubnetsCidrs = [
      for idx, cidr in module.vpc_pn_spid_hub.private_subnets_cidr_blocks:
          cidr
            if contains( var.vpc_pn_spid_hub_private_subnets_cidr, cidr)
    ]
}
