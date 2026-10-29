# DNS records are managed in CORE. Creating this identity does not wait for DKIM
# verification, so the period before publishing its CNAME records can be tested.
resource "aws_sesv2_email_identity" "mail" {
  count = var.ses_mail_identity == null ? 0 : 1

  email_identity         = var.ses_mail_identity.domain_name
  configuration_set_name = var.ses_mail_identity.configuration_set_name

  dkim_signing_attributes {
    next_signing_key_length = "RSA_2048_BIT"
  }
}

resource "aws_sesv2_email_identity_feedback_attributes" "mail" {
  count = var.ses_mail_identity == null ? 0 : 1

  email_identity           = aws_sesv2_email_identity.mail[0].email_identity
  email_forwarding_enabled = var.ses_mail_identity.email_forwarding_enabled
}
