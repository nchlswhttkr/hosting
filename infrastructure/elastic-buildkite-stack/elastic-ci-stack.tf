resource "aws_cloudformation_stack" "buildkite" {
  name         = "elastic-buildkite-stack"
  template_url = "https://s3.amazonaws.com/buildkite-aws-stack/v6.35.0/aws-stack.yml"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    # https://buildkite.com/docs/agent/v3/elastic-ci-aws/parameters
    BuildkiteAgentTokenParameterStorePath = resource.aws_ssm_parameter.buildkite_agent_token.name

    # Auto-scaling EC2 instances
    MaxSize            = 3
    InstanceTypes      = "t3a.small"
    RootVolumeSize     = 20
    OnDemandPercentage = 0
    BootstrapScriptUrl = "s3://${aws_s3_bucket.bootstrap.bucket}/${aws_s3_object.agent_bootstrap_script.id}"
    AgentEnvFileUrl    = "s3://${aws_s3_bucket.bootstrap.bucket}/${aws_s3_object.agent_environment_file.id}"
    ManagedPolicyARNs  = aws_iam_policy.buildkite_agent.arn

    # Misc
    EnableCostAllocationTags = true
    CostAllocationTagName    = "Project"
    CostAllocationTagValue   = local.aws_tags["Project"]

    # Buildkite agent settings
    AgentsPerInstance            = 2
    BuildkiteAgentExperiments    = "resolve-commit-after-checkout"
    BuildkiteAgentTracingBackend = "opentelemetry"
  }
}

resource "buildkite_agent_token" "elastic" {
  description = "Agent token for my autoscaling Buildkite agent"
}

resource "aws_ssm_parameter" "buildkite_agent_token" {
  name  = "/elastic-buildkite-stack/buildkite-agent-token"
  type  = "String"
  value = buildkite_agent_token.elastic.token
}

resource "aws_s3_object" "agent_environment" {
  bucket                 = aws_cloudformation_stack.buildkite.outputs.ManagedSecretsBucket
  key                    = "environment"
  server_side_encryption = "aws:kms"
  content                = <<-EOF
    #!/bin/bash
    set -euo pipefail

    export BUILDKITE_GIT_FETCH_FLAGS="-v --prune --tags"
    export VAULT_ADDR="https://vault.nicholas.cloud"

    BUILDKITE_OIDC_JWT="$(buildkite-agent oidc request-token --audience vault.nicholas.cloud)"
    VAULT_TOKEN="$(vault write -format=json auth/buildkite/login role=buildkite-agent jwt="$BUILDKITE_OIDC_JWT" | jq --raw-output ".auth.client_token")"
    unset BUILDKITE_OIDC_JWT
    export VAULT_TOKEN
  EOF
}

