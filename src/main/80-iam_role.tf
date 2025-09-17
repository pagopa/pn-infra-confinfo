locals {
  managed_policy_attachments = {
    for tuple in flatten([
      for role_name, config in var.external_roles_config : [
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

  inline_policy_attachments = {
    for tuple in flatten([
      for role_name, config in var.external_roles_config : [
        for inline_policy in config.inline_policies : {
          key         = "${role_name}.${inline_policy.name}"
          role_name   = role_name
          policy_name = inline_policy.name
          policy_file = inline_policy.file
        }
      ]
    ]) : tuple.key => {
      role_name   = tuple.role_name
      policy_name = tuple.policy_name
      policy_file = tuple.policy_file
    }
  }
}

resource "aws_iam_role" "external_role" {
  for_each = var.external_roles_config

  name = "${each.key}-confinfo-${var.environment}"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Action    = "sts:AssumeRole"
        Principal = {
          AWS = "arn:aws:iam::${var.pn_cicd_aws_account_id}:root"
        }
        Condition = {
          StringEquals = {
            "aws:PrincipalTag/pn-${each.key}-confinfo-${var.environment}" = "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = local.managed_policy_attachments

  role       = aws_iam_role.external_role[each.value.role_name].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.policy_name}"
}

resource "aws_iam_role_policy" "inline" {
  for_each = local.inline_policy_attachments

  name = each.value.policy_name
  role = aws_iam_role.external_role[each.value.role_name].id

  policy = jsonencode(
    jsondecode(
      templatefile(each.value.policy_file, {
        aws_region     = var.aws_region
        aws_account_id_core = var.pn_core_aws_account_id
        aws_account_id_confinfo = var.pn_confinfo_aws_account_id
      })
    )
  )
}