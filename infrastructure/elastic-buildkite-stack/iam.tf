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
    sid = "ReadTailscaleClientId"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [aws_ssm_parameter.tailscale_client_id.arn]
  }

  statement {
    sid = "AssumeRoleAndExternalIdentity"
    actions = [
      "sts:AssumeRoleWithWebIdentity",
      "sts:GetWebIdentityToken"
    ]
    resources = [
      "*" # For now we don't know the potential roles an agent might assume, it would be nice to attach policies CloudFormation stack's EC2 role but I don't want to touch "internals"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "buildkite_agent" {
  role       = aws_cloudformation_stack.buildkite.outputs["InstanceRoleName"]
  policy_arn = aws_iam_policy.buildkite_agent.arn
}
