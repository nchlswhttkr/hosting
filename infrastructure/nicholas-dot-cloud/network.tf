resource "digitalocean_vpc" "main" {
  name   = "nicholas-dot-cloud-${local.digitalocean_region}"
  region = local.digitalocean_region
}

resource "digitalocean_firewall" "web" {
  name = "nicholas-dot-cloud"
  tags = [local.digitalocean_web_server_tag]

  # Allow inbound HTTPS requests
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow inbound Tailscale requests
  inbound_rule {
    protocol         = "udp"
    port_range       = "41641"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound DNS requests (UDP)
  outbound_rule {
    protocol              = "udp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound DNS requests (TCP)
  outbound_rule {
    protocol              = "tcp"
    port_range            = "53"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound HTTP requests
  outbound_rule {
    protocol              = "tcp"
    port_range            = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound HTTPS requests
  outbound_rule {
    protocol              = "tcp"
    port_range            = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow outbound Tailscale requests
  outbound_rule {
    protocol              = "udp"
    port_range            = "41641"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow ICMP communication
  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
