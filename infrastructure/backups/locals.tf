locals {
  services = {
    vault = {
      name     = "Hashicorp Vault",
      schedule = "0 6 * * 6 Australia/Melbourne"
      pipeline = "backup-vault"
    }

    writefreely = {
      name = "Writefreely",
      # Every 4th SAT https://github.com/floraison/fugit#the-modulo-extension
      schedule = "0 6 * * 6%4 Australia/Melbourne"
      pipeline = "backup-writefreely"
    }
  }
}
