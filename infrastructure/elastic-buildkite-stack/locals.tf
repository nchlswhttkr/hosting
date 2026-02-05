locals {
  aws_tags = {
    Project = "Elastic Buildkite Stack"
  }

  buildkite_organization = "nchlswhttkr"

  # TODO: Consider adding notes about https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_outbound_web_identity_federation
  aws_outbound_identity_federation_issuer_url = "https://a1faa616-d595-447d-bdfd-64b774ab199c.tokens.sts.global.api.aws"

  # Static name to negate a circular dependency
  # Tailscale client -> stack IAM role -> bootstrap script -> Tailscale client
  bootstrap_script_name = "bootstrap.sh"
  environment_file_name = ".env"
}
