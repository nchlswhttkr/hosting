locals {
  services = {
    vault = {
      name     = "Hashicorp Vault",
      schedule = "0 6 * * 6 Australia/Melbourne"
      pipeline = "backup-vault"
    }
  }
}
