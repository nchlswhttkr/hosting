resource "aws_iam_policy" "buildkite_agent" {
  name   = "BuildkiteAgent"
  policy = data.aws_iam_policy_document.buildkite_agent.json

}

data "aws_iam_policy_document" "buildkite_agent" {
  statement {
    sid = "ListStateBucket"
    actions = [
      "s3:ListBucket"
    ]
    resources = [data.aws_ssm_parameter.state_bucket_arn.value]
  }

  statement {
    sid = "ManageStateBucketObjects"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["${data.aws_ssm_parameter.state_bucket_arn.value}/*"]
  }

  statement {
    sid = "ManageStateLockTable"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [data.aws_ssm_parameter.state_lock_table_arn.value]
  }
  statement {
    sid = "ReadBootstrapScript"
    actions = [
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.bootstrap.arn}/${aws_s3_object.bootstrap_script.id}"]
  }

  statement {
    sid = "ReadTailscaleAuthenticationKey"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [aws_ssm_parameter.tailscale_authentication_key.arn]
  }

  statement {
    sid = "DecryptSecretParameters"
    actions = [
      "kms:Decrypt"
    ]
    resources = [data.aws_kms_key.ssm_default.arn]
  }

  statement {
    sid = "AssumeRole"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    resources = [
      "*" # For now we don't know the potential roles an agent might assume, it would be nice to attach policies CloudFormation stack's EC2 role but I don't want to touch "internals"
    ]
  }
}
