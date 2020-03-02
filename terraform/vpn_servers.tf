resource digitalocean_droplet "vpn_servers" {
  name = "vpn.${var.dns_zone}"

  size               = "${var.vpn_servers["size"]}"
  region             = "${var.digital_ocean_region}"
  private_networking = "true"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  image              = "${var.base_image_id}"

  count = "${var.vpn_servers["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "vpn.${var.dns_zone}")}"
}


resource cloudflare_record "vpn_server_public_dns" {
  count = "${var.env_slug == "core" ? 1 : 0}"

# replace with your domain
  domain = "startup.com"  
  name   = "vpn.${var.dns_zone}"
  value  = "${digitalocean_droplet.vpn_servers.0.ipv4_address}"
  type   = "A"
  ttl    = "${var.internal_dns_ttl}"
}

resource "powerdns_record" "vpn_servers" {
  count = "${var.vpn_servers["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "vpn.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.vpn_servers.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "powerdns_record" "vpn_ca_servers" {
  count = "${var.vpn_servers["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "vpn-ca.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.vpn_ca_servers.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource digitalocean_droplet "vpn_ca_servers" {
  name = "vpn-ca.${var.dns_zone}"

  size               = "${var.vpn_ca_servers["size"]}"
  region             = "${var.digital_ocean_region}"
  private_networking = "true"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  image              = "${var.base_image_id}"

  count = "${var.vpn_ca_servers["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "vpn-ca.${var.dns_zone}")}"
}
