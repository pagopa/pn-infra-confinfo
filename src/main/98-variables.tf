variable "aws_region" {
  type        = string
  description = "AWS region to create resources. Default Milan"
  default     = "eu-south-1"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment"
}

variable "how_many_az" {
  type        = number
  default     = 3
  description = "How many Availability Zone we have to use"
}


variable "dns_zone" {
  type        = string
  description = "Dns zone used for the environment"
}

variable "api_domains" {
  type        = set(string)
  description = "List of regional api endpoint, entry in the dns zone. This parameter is used for ACM certificate creation"
}

variable "cdn_domains" {
  type        = set(string)
  description = "List of CDN domains"
}

variable "apigw_custom_domains" {
  type        = set(string)
  description = "List of API-GW custom domains"
}


variable "dns_record_ttl" {
  type        = number
  description = "Dns record ttl (in sec)"
  default     = 60 # 1 minute
}



variable "vpc_pn_confinfo_aws_services_interface_endpoints_subnets_cidr" {
  type        = list(string)
  description = "AWS services interfaces endpoints list of cidr."
}


variable "vpc_pn_confinfo_name" {
  type        = string
  description = "Name of the PN Confidential Informations VPC"
}

variable "vpc_pn_confinfo_primary_cidr" {
  type        = string
  description = "Primary CIDR of the PN Confidential Informations VPC"
}


variable "vpc_pn_confinfo_private_subnets_cidr" {
  type        = list(string)
  description = "Private subnets list of cidr."
}
variable "vpc_pn_confinfo_private_subnets_names" {
  type        = list(string)
  description = "Private subnets list of names."
}

variable "vpc_pn_confinfo_public_subnets_cidr" {
  type        = list(string)
  description = "Private subnets list of cidr."
}
variable "vpc_pn_confinfo_public_subnets_names" {
  type        = list(string)
  description = "Private subnets list of names."
}

variable "vpc_pn_confinfo_internal_subnets_cidr" {
  type        = list(string)
  description = "Internal subnets list of cidr"
}
variable "vpc_pn_confinfo_internal_subnets_names" {
  type        = list(string)
  description = "Internal subnets list of names"
}



variable "vpc_endpoints_pn_confinfo" {
  type        = list(string)
  description = "Endpoint List"
}





variable "vpc_pn_spid_hub_aws_services_interface_endpoints_subnets_cidr" {
  type        = list(string)
  description = "AWS services interfaces endpoints list of cidr."
}


variable "vpc_pn_spid_hub_name" {
  type        = string
  description = "Name of the PN Confidential Informations VPC"
}

variable "vpc_pn_spid_hub_primary_cidr" {
  type        = string
  description = "Primary CIDR of the PN Confidential Informations VPC"
}


variable "vpc_pn_spid_hub_private_subnets_cidr" {
  type        = list(string)
  description = "Private subnets list of cidr."
}
variable "vpc_pn_spid_hub_private_subnets_names" {
  type        = list(string)
  description = "Private subnets list of names."
}

variable "vpc_pn_spid_hub_public_subnets_cidr" {
  type        = list(string)
  description = "Private subnets list of cidr."
}
variable "vpc_pn_spid_hub_public_subnets_names" {
  type        = list(string)
  description = "Private subnets list of names."
}

variable "vpc_pn_spid_hub_internal_subnets_cidr" {
  type        = list(string)
  description = "Internal subnets list of cidr"
}
variable "vpc_pn_spid_hub_internal_subnets_names" {
  type        = list(string)
  description = "Internal subnets list of names"
}



variable "vpc_endpoints_pn_spid_hub" {
  type        = list(string)
  description = "Endpoint List"
}
