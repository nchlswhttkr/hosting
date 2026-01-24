resource "aws_s3_bucket" "backups" {
  bucket = "nchlswhttkr-backups"
}

resource "aws_s3_bucket_versioning" "backups" {
  bucket = aws_s3_bucket.backups.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id

  rule {
    id     = "default"
    status = "Enabled"

    transition {
      storage_class = "INTELLIGENT_TIERING"
      days          = 0
    }

  }
}

resource "aws_ssm_parameter" "backups" {
  name  = "/backups/backups-bucket-name"
  type  = "String"
  value = aws_s3_bucket.backups.id
}
