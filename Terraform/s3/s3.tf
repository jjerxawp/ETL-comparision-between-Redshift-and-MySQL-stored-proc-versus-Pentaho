
resource "aws_s3_bucket" "asm3_s3_bucket" {
  bucket_prefix = "asm3-redshift-"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "asm3_s3_versioning" {
  bucket = aws_s3_bucket.asm3_s3_bucket.id

  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "asm3_s3_ownership" {
  bucket = aws_s3_bucket.asm3_s3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "asm3_s3_access_config" {
  bucket = aws_s3_bucket.asm3_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "asm3_s3_bucket_acl" {
  depends_on = [
    aws_s3_bucket_versioning.asm3_s3_versioning,
    aws_s3_bucket_ownership_controls.asm3_s3_ownership,
    aws_s3_bucket_public_access_block.asm3_s3_access_config
  ]

  bucket = aws_s3_bucket.asm3_s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "asm3_data_uploading" {
  depends_on = [aws_s3_bucket_acl.asm3_s3_bucket_acl]
  bucket     = aws_s3_bucket.asm3_s3_bucket.id

  for_each = var.data_uploading
  key      = each.key
  source   = each.value

  force_destroy = true
}

output "s3_id" {
  value = aws_s3_bucket.asm3_s3_bucket.id
}


