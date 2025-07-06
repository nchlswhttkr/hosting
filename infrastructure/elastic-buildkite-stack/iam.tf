resource "aws_iam_policy" "buildkite_agent" {
  name   = "BuildkiteAgent"
  policy = data.aws_iam_policy_document.buildkite_agent.json

}

data "aws_iam_policy_document" "buildkite_agent" {
  statement {
    sid = "ReadBootstrapScript"
    actions = [
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.bootstrap.arn}/*"]
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

data "aws_kms_key" "ssm_default" {
  key_id = "alias/aws/ssm"
}
