resource "aws_iam_openid_connect_provider" "buildkite" {
  url            = "https://agent.buildkite.com"
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    data.tls_certificate.buildkite.certificates[0].sha1_fingerprint,
  ]
}

data "tls_certificate" "buildkite" {
  url = "https://agent.buildkite.com"
}

resource "aws_ssm_parameter" "buildkite_oidc_provider_arn" {
  provider = aws.melbourne

  name  = "/elastic-buildkite-stack/buildkite-oidc-provider-arn"
  type  = "String"
  value = aws_iam_openid_connect_provider.buildkite.arn
}
