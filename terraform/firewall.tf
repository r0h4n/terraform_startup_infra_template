resource "digitalocean_tag" "internal_access_only" {
  name = "internal_access_only_${var.env_slug}"
}


resource digitalocean_firewall "internal_access_only" {
  name = "ssh-access-only-from-vpn-${var.env_slug}"

  tags = ["${digitalocean_tag.internal_access_only.id}"]

  inbound_rule = [
    {
      protocol = "tcp"
      port_range = "22"
      source_addresses = ["10.0.0.0/8"]
    }
  ]

  outbound_rule = [
    {
      protocol = "tcp"
      port_range = "all"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol = "udp"
      port_range = "all"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}

resource "digitalocean_tag" "https_access_from_loadbalancer_only" {
  name = "https_access_from_loadbalancer_only_${var.env_slug}"
}

resource digitalocean_firewall "https_only_from_loadbalancer" {
  name = "http-https-only-from-loadbalancer-${var.env_slug}"

  tags = ["${digitalocean_tag.https_access_from_loadbalancer_only.id}"]

  inbound_rule = [
      {
        protocol = "tcp"
        port_range = "80"
        source_tags = ["${digitalocean_tag.loadbalancer.id}"]
      },
      {
        protocol = "tcp"
        port_range = "443"
        source_tags = ["${digitalocean_tag.loadbalancer.id}"]
      }
  ]
}

resource digitalocean_firewall "postgresql_access_only_from_replicas" {
  name = "postgresql-access-only-from-replicas-${var.env_slug}"

  tags = ["${digitalocean_tag.primary_db_server.id}"]

  inbound_rule = [
      {
        protocol = "tcp"
        port_range = "5432"
        source_tags = ["${digitalocean_tag.replica_db_server.id}"]
      }
  ]
}

resource digitalocean_tag "public_http_https_access" {
  name = "public_http_https_access_${var.env_slug}"
}

resource digitalocean_firewall "public_http_https_access" {
  name = "public-http-https-access-${var.env_slug}"

  tags = ["${digitalocean_tag.public_http_https_access.id}"]

  inbound_rule = [
      {
        protocol = "tcp"
        port_range = "80"
        source_addresses = ["0.0.0.0/0", "::/0"]
      },
      {
        protocol = "tcp"
        port_range = "443"
        source_addresses = ["0.0.0.0/0", "::/0"]
      }
  ]
}


