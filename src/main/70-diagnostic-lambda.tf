locals {
  safestorage_bucket       = "pn-safestorage-${var.aws_region}-${var.pn_confinfo_aws_account_id}"
  data_proxy_function_name = "diagnostic-data-proxy"
  diagnostic_role_prefix   = "Diagnostic"
  data_proxy_filename      = "${path.root}/../../functions/diagnostic-data-proxy/function.zip"
  data_proxy_runtime       = "nodejs18.x"
  data_proxy_role_callers = [
    "diagnostic-get-timeline-element-events-Role",
    "diagnostic-get-file-Role"
  ]
}

# Configuring and deploying the Lambda 
module "diagnostic_data_proxy" {
  source = "./modules/diagnostic-data-proxy"

  filename                   = local.data_proxy_filename
  function_name              = local.data_proxy_function_name
  aws_region                 = var.aws_region
  pn_confinfo_aws_account_id = var.pn_confinfo_aws_account_id
  handler                    = "index.handler"
  runtime                    = local.data_proxy_runtime
  safestorage_bucket         = local.safestorage_bucket
}

# Creation of an IAM role for the Lambda function with an assume role policy 
# that authorizes only specific roles in pn-core
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
            "aws:PrincipalArn" = [for role in local.data_proxy_role_callers : "arn:aws:iam::${var.pn_core_aws_account_id}:role/service-role/${role}"]
          }
        }
        Sid = ""
      },
    ],
  })
}

# Allows the diagnostic_role to invoke the Lambda
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
