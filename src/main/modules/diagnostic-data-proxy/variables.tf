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

variable "pn_confinfo_aws_account_id" {
  type        = string
  description = "AWS pn-confinfo account id"
}

variable "handler" {
  description = "Handler Lambda"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "NodeJs runtime"
  type        = string
  default     = "nodejs22.x"
}

variable "safestorage_bucket" {
  description = "Safestorage bucket"
  type        = string
}

variable "lambda_tags" {
  type        = map(string)
  default     = {}
  description = "Tags for Lambda resource"
}