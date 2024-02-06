locals {
  safestorage_bucket       = "pn-safestorage-${var.aws_region}-${var.pn_confinfo_aws_account_id}"
  data_proxy_function_name = "diagnostic-data-proxy"
  diagnostic_role_prefix   = "Diagnostic"
  data_proxy_filename      = "${path.root}/../../functions/diagnostic-data-proxy/function.zip"
  data_proxy_callers       = [ 
    "arn:aws:iam::${var.pn_core_aws_account_id}:role/service-role/retool-getTimelineElementEvents-role-c7cflrlo",
    "arn:aws:iam::${var.pn_core_aws_account_id}:role/service-role/retool-getFile-role-2vc7g235"
  ]
}

module "diagnostic_data_proxy" {
  source = "./modules/diagnostic-data-proxy"

  filename                   = local.data_proxy_filename
  function_name              = local.data_proxy_function_name
  s3_code_bucket             = var.lambda_s3_code_bucket
  s3_code_key                = var.diagnostic_data_proxy_s3_code_key
  aws_region                 = var.aws_region
  pn_confinfo_aws_account_id = var.pn_confinfo_aws_account_id
  handler                    = "index.handler"
  runtime                    = var.diagnostic_data_proxy_runtime
  safestorage_bucket         = local.safestorage_bucket
}

resource "aws_iam_role" "diagnostic_role" {
  name = "${local.diagnostic_role_prefix}AssumeRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          AWS = [
            "arn:aws:iam::${var.pn_core_aws_account_id}:root",
          ]
        },
        Condition = {
          ArnEquals = {
            "aws:SourceArn": local.data_proxy_callers
          }
        }
        Sid = ""
      },
    ],
  })
}

resource "aws_iam_role_policy" "diagnostic_lambda_invoke_policy" {
  name = "${local.diagnostic_role_prefix}LambdaInvoke"
  role = aws_iam_role.diagnostic_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "lambda:InvokeFunction",
        Resource = module.diagnostic_data_proxy.function_arn
      }
    ],
  })
}
