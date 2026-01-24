resource "buildkite_pipeline" "service" {
  for_each = local.services

  name           = each.value.pipeline
  repository     = "git@github.com:nchlswhttkr/hosting.git"
  default_branch = "main"

  provider_settings = {
    trigger_mode = "none"
  }

  steps = yamlencode({
    steps = [
      {
        label   = ":pipeline:"
        command = "buildkite-agent pipeline upload .buildkite/backup-${each.key}/pipeline.yml"
        agents = {
          queue = "upload"
        }
      }
    ]
  })
}

resource "buildkite_pipeline_schedule" "service" {
  for_each = local.services

  pipeline_id = buildkite_pipeline.service[each.key].id
  label       = "Back up ${each.value.name}"
  cronline    = each.value.schedule
  branch      = buildkite_pipeline.service[each.key].default_branch
}
