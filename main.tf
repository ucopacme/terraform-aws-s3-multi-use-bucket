resource "aws_s3_bucket" "this" {
  acl           = var.acl
  bucket        = var.bucket
  count         = var.enabled ? 1 : 0
  force_destroy = var.force_destroy
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_arn
      }
    }
  }
  tags = merge(var.tags, map("Name", var.bucket))
  versioning {
    enabled = var.versioning_enabled
  }
  lifecycle_rule {
    enabled = var.lifecycle_rule_enabled
    expiration {
      days = var.expiration_days
    }
    id     = var.lifecycle_id
    prefix = var.prefix
    transition {
      days          = var.standard_transition_days
      storage_class = var.infrequent_access_type
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  bucket                  = join("", aws_s3_bucket.this.*.id)
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.policy_enabled ? 1 : 0
  bucket = join("", aws_s3_bucket.this.*.id)
  policy = var.policy
}

