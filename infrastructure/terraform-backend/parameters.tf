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
