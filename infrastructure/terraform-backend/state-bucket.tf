resource "aws_s3_bucket" "state" {
  bucket = "nchlswhttkr-terraform-backend"
}

resource "aws_s3_bucket_acl" "state" {
  bucket = aws_s3_bucket.state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    id     = "ExpireNoncurrentVersionsAfter90Days"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

resource "aws_dynamodb_table" "state_lock" {
  name           = "nchlswhttkr-terraform-backend"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_ssm_parameter" "state_bucket_arn" {
  name  = "/terraform-backend/state-bucket-arn"
  type  = "String"
  value = aws_s3_bucket.state.arn
}

resource "aws_ssm_parameter" "state_lock_table_arn" {
  name  = "/terraform-backend/state-lock-table-arn"
  type  = "String"
  value = aws_dynamodb_table.state_lock.arn
}
