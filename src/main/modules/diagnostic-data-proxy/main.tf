# Data source to retrieve the checksum of the Lambda function code stored in an S3 bucket
data "aws_s3_object" "lambda_code_object" {
  count  = var.filename == null ? 1 : 0
  bucket = var.s3_code_bucket
  key    = var.s3_code_key
}

# Lambda function resource definition
resource "aws_lambda_function" "diagnostic_data_proxy_lambda" {
  function_name = var.function_name
  filename      = var.filename != null ? var.filename : null
  s3_bucket     = var.filename == null ? var.s3_code_bucket : null
  s3_key        = var.filename == null ? var.s3_code_key : null
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  role          = aws_iam_role.lambda_role.arn

  # Dynamically calculates source code hash based on if the code is uploaded as a file or from S3
  source_code_hash = (var.filename != null ?
    filebase64sha256(var.filename) :
  sha256(data.aws_s3_object.lambda_code_object.last_modified))
  #   data.aws_s3_object.lambda_code_object.checksum_sha256)
  # Update aws provider version to have checksum_sha256

  # Environment variables for the Lambda function
  environment {
    variables = {
      SAFESTORAGE_BUCKET = var.safestorage_bucket
      DYNAMO_AWS_REGION  = var.aws_region
      S3_AWS_REGION      = var.aws_region
    }
  }

  # Ensures that either a direct upload filename or S3 location must be specified
  lifecycle {
    precondition {
      condition     = var.filename != null || (var.s3_code_bucket != null && var.s3_code_key != null)
      error_message = "Either filename must be specified, or both s3_bucket and s3_key must be provided."
    }
  }
}

# IAM role for the Lambda function, allowing it to assume the Lambda service role
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-ExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Effect = "Allow",
        Sid    = ""
      },
    ],
  })
}

# IAM policy attached to the role for creating and managing logs
resource "aws_iam_role_policy" "lambda_logs_policy" {
  name = "${var.function_name}-LogsPolicy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:${var.aws_region}:${var.pn_confinfo_aws_account_id}:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:${var.aws_region}:${var.pn_confinfo_aws_account_id}:log-group:/aws/lambda/${var.function_name}:*"
        ]
      }
    ],
  })
}

# IAM policy for accessing DynamoDB
resource "aws_iam_role_policy" "lambda_dynamo_policy" {
  name = "${var.function_name}-DynamoPolicy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query"
        ]
        Resource = "arn:aws:dynamodb:${var.aws_region}:${var.pn_confinfo_aws_account_id}:*"
      },
      {
        Effect = "Allow",
        Action = "kms:Decrypt",
        Resource = [
          "arn:aws:kms:${var.aws_region}:${var.pn_confinfo_aws_account_id}:key/*"
        ]
      }
    ],
  })
}

# IAM policy for accessing S3
resource "aws_iam_role_policy" "lambda_s3_policy" {
  name = "${var.function_name}-S3Policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectTagging",
          "s3:GetObjectRetention",
          "s3:ListBucket",
          "s3:RestoreObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.safestorage_bucket}",
          "arn:aws:s3:::${var.safestorage_bucket}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = "kms:Decrypt",
        Resource = [
          "arn:aws:kms:${var.aws_region}:${var.pn_confinfo_aws_account_id}:key/*"
        ]
      }
    ],
  })
}
