locals {
  oncall_tag = {
    OnCallExec = "True"
  }

  diagnostic_role_callers = [
    "diagnostic-tools-ExecutionRole",
    "diagnostic-list-lambda-ExecutionRole"
  ]
  diagnostic_role_callers_account_id = var.pn_core_aws_account_id
  diagnostic_role_prefix             = "Diagnostic"

  safestorage_bucket       = "pn-safestorage-${var.aws_region}-${var.pn_confinfo_aws_account_id}"
  data_proxy_function_name = "diagnostic-data-proxy"
  data_proxy_current_build = file("${path.root}/../../functions/diagnostic-data-proxy/.current_build")
  data_proxy_filename      = "${path.root}/../../functions/diagnostic-data-proxy/${local.data_proxy_current_build}"
  data_proxy_runtime       = "nodejs18.x"

  list_lambda_function_name = "diagnostic-list-lambda"
  list_lambda_current_build = file("${path.root}/../../functions/diagnostic-list-lambda/.current_build")
  list_lambda_filename      = "${path.root}/../../functions/diagnostic-list-lambda/${local.list_lambda_current_build}"
  list_lambda_runtime       = "nodejs18.x"
}

# Configuring and deploying data-proxy
module "diagnostic_data_proxy" {
  source = "./modules/diagnostic-data-proxy"

  filename                   = local.data_proxy_filename
  function_name              = local.data_proxy_function_name
  aws_region                 = var.aws_region
  pn_confinfo_aws_account_id = var.pn_confinfo_aws_account_id
  handler                    = "index.handler"
  runtime                    = local.data_proxy_runtime
  safestorage_bucket         = local.safestorage_bucket
  lambda_tags                = local.oncall_tag
}

# Configuring and deploying list-lambda
module "diagnostic_list_lambda" {
  source = "./modules/diagnostic-list-lambda"

  filename                 = local.list_lambda_filename
  function_name            = local.list_lambda_function_name
  aws_region               = var.aws_region
  handler                  = "index.handler"
  runtime                  = local.list_lambda_runtime
  current_aws_account_id   = var.pn_confinfo_aws_account_id
  current_aws_account_name = "confinfo"
  lambda_tags              = local.oncall_tag
}

# Creation of an IAM role for diagnostic functions with an assume role policy 
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
            "aws:PrincipalArn" = [
              for role in local.diagnostic_role_callers :
              "arn:aws:iam::${local.diagnostic_role_callers_account_id}:role/${role}"
            ]
          }
        }
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
        Effect = "Allow",
        Action = "lambda:InvokeFunction",
        Resource = [
          module.diagnostic_data_proxy.function_arn,
          module.diagnostic_list_lambda.function_arn
        ]
      }
    ],
  })
}
