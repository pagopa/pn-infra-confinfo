variable "function_name" {
  type        = string
  default     = "diagnostic-data-proxy"
  description = "The name of the Lambda."
}

variable "s3_code_bucket" {
  type        = string
  default     = null
  description = "The name of the S3 bucket from which to load the Lambda code. Required if filename is not specified."
}

variable "s3_code_key" {
  type        = string
  default     = null
  description = "The S3 key of the Lambda code ZIP file. Required if filename is not specified."
}

variable "filename" {
  type        = string
  default     = null
  description = "Local path to the Lambda code ZIP file. If not specified, s3_bucket and s3_key must be used."
}

variable "memory_size" {
  type        = number
  default     = 128
  description = "The memory of the lambda."
}

variable "timeout" {
  type        = number
  default     = 3
  description = "The timeout of the lambda."
}

variable "aws_region" {
  type        = string
  description = "AWS region to create resources"
}

variable "handler" {
  description = "Handler Lambda"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "NodeJs runtime"
  type        = string
  default     = "nodejs18.x"
}

variable "current_aws_account_id" {
  type        = string
  description = "Current AWS account id."
}

variable "current_aws_account_name" {
  type        = string
  description = "Current AWS account name."
  validation {
    condition     = contains(["core", "confinfo"], var.current_aws_account_name)
    error_message = "The current_aws_account_name must be either 'core' or 'confinfo'."
  }
}

variable "confinfo_lambda_name" {
  type        = string
  default     = "none"
  description = "The lambda to invoke."
}

variable "confinfo_asuume_role_arn" {
  type        = string
  default     = "none"
  description = "Role to assume in confinfo."
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "VPC id"
}

variable "vpc_subnet_ids" {
  type        = list(string)
  default     = []
  description = "VPC subent ids"
}

variable "lambda_tags" {
  type        = map(string)
  default     = {}
  description = "Tags for Lambda resource"
}
