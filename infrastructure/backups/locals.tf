locals {
  services = {
    vault = {
      name     = "Hashicorp Vault",
      schedule = "0 6 * * 6 Australia/Melbourne"
      pipeline = "hosting-backup-vault"
    }
    plausible = {
      name     = "Plausible Analytics",
      schedule = "0 6 * * 6 Australia/Melbourne"
      pipeline = "hosting-backup-plausible"
    }
    write = {
      name     = "Writefreely",
      schedule = "0 6 * * 6 Australia/Melbourne"
      pipeline = "hosting-backup-write"
    }
  }
}
