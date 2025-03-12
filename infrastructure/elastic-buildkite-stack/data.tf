data "aws_ssm_parameter" "state_bucket_arn" {
  provider = aws.melbourne

  name = "/terraform-backend/state-bucket-arn"
}

data "aws_ssm_parameter" "state_lock_table_arn" {
  provider = aws.melbourne

  name = "/terraform-backend/state-lock-table-arn"
}

data "aws_kms_key" "ssm_default" {
  key_id = "alias/aws/ssm"
}

data "vault_kv_secret_v2" "honeycomb" {
  mount = "kv"
  name  = "nchlswhttkr/honeycomb"
}
