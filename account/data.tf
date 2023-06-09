data "aws_caller_identity" "current" {}

data "aws_kms_key" "basic" {
  key_id = "alias/basic-data-kms-key"
}
