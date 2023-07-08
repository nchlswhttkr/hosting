# TODO: Manage this SSH key via Terraform
resource "digitalocean_ssh_key" "remote_user" {
  name       = "Remote access for machines hosting nicholas.cloud"
  public_key = file("./remote-user.pub")
}

locals {
  digitalocean_region         = "syd1"
  digitalocean_web_server_tag = "nicholas-dot-cloud-web-servers"
}

resource "digitalocean_project" "nicholas_dot_cloud" {
  name        = "nicholas.cloud"
  description = "Resources hosting nicholas.cloud"
  environment = "Production"
}

resource "digitalocean_project_resources" "nicholas_dot_cloud" {
  project   = digitalocean_project.nicholas_dot_cloud.id
  resources = [digitalocean_droplet.web.urn]
}

resource "digitalocean_droplet" "web" {
  image      = "ubuntu-22-04-x64"
  name       = "gandra-dee"
  region     = local.digitalocean_region
  size       = "s-1vcpu-1gb"
  ssh_keys   = [digitalocean_ssh_key.remote_user.fingerprint]
  monitoring = true
  vpc_uuid   = digitalocean_vpc.main.id
  tags       = [local.digitalocean_web_server_tag]

  user_data = <<-EOF
#cloud-config
---
apt:
  sources:
    tailscale.list:
      source: "deb https://pkgs.tailscale.com/stable/ubuntu jammy main"
      key: ${jsonencode(data.http.tailscale_signing_key.response_body)}
packages:
  - "tailscale"
snap:
  commands:
    - snap install core
    - snap refresh core
    - snap install --classic certbot
users:
  - name: nchlswhttkr
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
runcmd:
  - ["tailscale", "up", "--ssh", "--auth-key", "${tailscale_tailnet_key.web.key}"]
  - ["ln", "-s", "/snap/bin/certbot", "/usr/bin/certbot"]
EOF
}

data "http" "tailscale_signing_key" {
  url = "https://pkgs.tailscale.com/stable/ubuntu/jammy.gpg"
}

# TODO: This may be recreated by Terraform once it's cleared from Tailscale
resource "tailscale_tailnet_key" "web" {
  expiry = 3600 # 1 hour
}
