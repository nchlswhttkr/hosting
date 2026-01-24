locals {
  aws_tags = {
    Project = "Backups"
  }

  buildkite_organization = "nchlswhttkr"

  services = {
    vault = {
      name     = "Hashicorp Vault",
      schedule = "0 6 * * 6 Australia/Melbourne"
      pipeline = "backup-vault"
    }
  }
}
