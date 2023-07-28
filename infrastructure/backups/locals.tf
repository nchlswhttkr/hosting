locals {
  services = {
    vault = {
      name     = "Hashicorp Vault",
      schedule = "0 6 * * 6 Australia/Melbourne"
    }
    plausible = {
      name     = "Plausible Analytics",
      schedule = "0 6 * * 6 Australia/Melbourne"
    }
    write = {
      name     = "Writefreely",
      schedule = "0 6 * * 6 Australia/Melbourne"
    }
  }
}
