resource "aws_iam_role" "iam_ext_role" {
  for_each = var.iam_ext_roles_config

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
  for_each = local.iam_managed_policy_attachments

  role       = aws_iam_role.iam_ext_role[each.value.role_name].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.policy_name}"
}

resource "aws_iam_role_policy" "inline" {
  for_each = local.iam_inline_policy_attachments

  name = each.value.policy_name
  role = aws_iam_role.iam_ext_role[each.value.role_name].id

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