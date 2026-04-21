locals {
  aws_tags = {
    Project = "Elastic Buildkite Stack"
  }

  buildkite_organization = "nchlswhttkr"

  # Static name to negate a circular dependency
  # Tailscale client -> stack IAM role -> bootstrap script -> Tailscale client
  bootstrap_script_name = "bootstrap.sh"
  environment_file_name = ".env"
}
