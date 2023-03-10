data "aws_ssm_parameter" "state_bucket_arn" {
  provider = aws.melbourne

  name = "/terraform-backend/state-bucket-arn"
}

data "aws_ssm_parameter" "state_lock_table_arn" {
  provider = aws.melbourne

  name = "/terraform-backend/state-lock-table-arn"
}
