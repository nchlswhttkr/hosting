output "state-bucket-arn" {
  value = aws_ssm_parameter.state_bucket_arn.arn
}

output "state-lock-table-arn" {
  value = aws_ssm_parameter.state_lock_table_arn.arn
}
