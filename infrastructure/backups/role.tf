resource "aws_iam_role" "backups" {
  name               = "Backups"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  inline_policy {
    name   = "UploadBackups"
    policy = data.aws_iam_policy_document.upload_backups.json
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_ssm_parameter.buildkite_oidc_provider_arn.value]
    }
    condition {
      test     = "StringLike"
      variable = "agent.buildkite.com:sub"
      values   = [for service in values(local.services) : "organization:nchlswhttkr:pipeline:${service.pipeline}:*"]
    }
  }
}

data "aws_iam_policy_document" "upload_backups" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.backups.arn}/*"
    ]
  }
  statement {
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      aws_ssm_parameter.backups.arn
    ]
  }
}
