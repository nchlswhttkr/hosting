resource "aws_cloudformation_stack" "buildkite" {
  name         = "elastic-buildkite-stack"
  template_url = "https://s3.amazonaws.com/buildkite-aws-stack/v5.19.0/aws-stack.yml"
  capabilities = ["CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    # https://buildkite.com/docs/agent/v3/elastic-ci-aws/parameters
    BuildkiteAgentTokenParameterStorePath = resource.aws_ssm_parameter.buildkite_agent_token.name

    # Auto-scaling EC2 instances
    MaxSize            = 3
    InstanceType       = "t3a.small"
    RootVolumeSize     = 20
    OnDemandPercentage = 0
    BootstrapScriptUrl = "s3://${aws_s3_bucket.bootstrap.bucket}/${aws_s3_object.bootstrap_script.id}"
    ManagedPolicyARN   = aws_iam_policy.buildkite_agent.arn

    # Misc
    EnableCostAllocationTags = true
    CostAllocationTagName    = "Project"
    CostAllocationTagValue   = local.aws_tags["Project"]

    # Buildkite agent settings
    AgentsPerInstance         = 2
    ScaleInIdlePeriod         = 600 # 10 minutes
    BuildkiteAgentExperiments = "ansi-timestamps,resolve-commit-after-checkout"
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
