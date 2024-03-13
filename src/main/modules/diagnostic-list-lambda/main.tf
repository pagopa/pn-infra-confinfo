# Lambda function resource definition
resource "aws_lambda_function" "diagnostic_list_lambda" {
  function_name = var.function_name
  filename      = var.filename != null ? var.filename : null
  s3_bucket     = var.filename == null ? var.s3_code_bucket : null
  s3_key        = var.filename == null ? var.s3_code_key : null
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout
  role          = aws_iam_role.lambda_role.arn
  tags          = var.lambda_tags

  # Dynamically calculates source code hash based on if the code is uploaded as a file or from S3
  source_code_hash = (var.filename != null ? filebase64sha256(var.filename) : sha256(var.s3_code_key))

  # Environment variables for the Lambda function
  environment {
    variables = {
      CURRENT_REGION           = var.aws_region
      CURRENT_ACCOUNT          = var.current_aws_account_name
      CONFINFO_LAMBDA_NAME     = var.confinfo_lambda_name
      CONFINFO_LAMBDA_REGION   = var.aws_region
      CONFINFO_ASSUME_ROLE_ARN = var.confinfo_asuume_role_arn
    }
  }

  # Add vpc_config only if vpc_id is defined
  dynamic "vpc_config" {
    for_each = var.vpc_id != null ? [1] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = [aws_security_group.lambda_security_group[0].id]
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
        Resource = "arn:aws:logs:${var.aws_region}:${var.current_aws_account_id}:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:${var.aws_region}:${var.current_aws_account_id}:log-group:/aws/lambda/${var.function_name}:*"
        ]
      }
    ],
  })
}

# IAM policy attached to the role for getting all resources based on tag
resource "aws_iam_role_policy" "lambda_tags_policy" {
  name = "${var.function_name}-TagsPolicy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "tag:GetResources",
        Resource = "*"
      }
    ],
  })
}

resource "aws_iam_role_policy" "lambda_invoke_function_policy" {
  # Make resource only if is running on core
  count = var.current_aws_account_name == "core" ? 1 : 0
  name = "${var.function_name}-InvokePolicy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = var.confinfo_asuume_role_arn
      }
    ],
  })
}

resource "aws_iam_role_policy_attachment" "attach_vpc" {
  # Make resource only if vpc_id is defined
  count       = var.vpc_id != null ? 1 : 0
  role      = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Security group to query pn-datavault
resource "aws_security_group" "lambda_security_group" {
  # Make resource only if vpc_id is defined
  count       = var.vpc_id != null ? 1 : 0
  name        = "${var.function_name}-sec-group"
  description = "${var.function_name}-sec-group"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
