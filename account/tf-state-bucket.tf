resource "aws_s3_bucket" "state" {
  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "terraform-${data.aws_caller_identity.current.account_id}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.basic.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}