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
  image      = "ubuntu-24-04-x64"
  name       = "blog"
  region     = local.digitalocean_region
  size       = "s-1vcpu-512mb-10gb"
  monitoring = true
  vpc_uuid   = digitalocean_vpc.main.id
  tags       = [local.digitalocean_web_server_tag]

  user_data = <<-EOF
    #cloud-config
    ---
    apt:
      sources:
        tailscale.list:
          source: "deb https://pkgs.tailscale.com/stable/ubuntu noble main"
          key: ${jsonencode(data.http.tailscale_signing_key.response_body)}
    packages:
      - "tailscale"
    snap:
      commands:
        - snap install core
        - snap refresh core
        - snap install --classic certbot
        - snap set certbot trust-plugin-with-root=ok
        - snap install certbot-dns-cloudflare
    users:
      - name: nchlswhttkr
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
    runcmd:
      - ["ln", "-s", "/snap/bin/certbot", "/usr/bin/certbot"]
      - ["tailscale", "up", "--ssh", "--auth-key", "${tailscale_tailnet_key.web.key}"]
  EOF

  lifecycle {
    ignore_changes = [user_data]
  }
}

data "http" "tailscale_signing_key" {
  url = "https://pkgs.tailscale.com/stable/ubuntu/noble.gpg"
}

resource "tailscale_tailnet_key" "web" {
  expiry              = 300 # 5 minutes
  preauthorized       = true
  tags                = ["tag:project-blog"]
  recreate_if_invalid = "always"
}

resource "cloudflare_dns_record" "web" {
  name    = "@"
  ttl     = 1
  type    = "A"
  zone_id = data.cloudflare_zones.web.result[0].id
  content = digitalocean_droplet.web.ipv4_address
  proxied = true
}

data "cloudflare_zones" "web" {
  name = "nicholas.cloud"
}
