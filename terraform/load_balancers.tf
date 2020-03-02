resource digitalocean_tag "loadbalancer" {
  name = "loadbalancer-${var.env_slug}"
}

## Blue (you can add a "Green" deployment)
resource digitalocean_droplet "loadbalancers_blue" {
  name = "lb0${count.index}.${var.dns_zone}"

  size               = "${var.loadbalancers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "true"
  tags               = [
    "${digitalocean_tag.loadbalancer.id}",
    "${digitalocean_tag.internal_access_only.id}",
    "${digitalocean_tag.public_http_https_access.id}"
  ]

  count = "${var.loadbalancers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "lb0${count.index}.${var.dns_zone}")}"
}

resource powerdns_record "loadbalancers_blue" {
  count = "${var.loadbalancers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "lb0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.loadbalancers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}


resource digitalocean_floating_ip "loadbalancers" {
  droplet_id = "${digitalocean_droplet.loadbalancers_blue.0.id}"
  region     = "${var.digital_ocean_region}"

  count = "${var.loadbalancers_blue["count"]}"
}

resource cloudflare_record "api_public_dns" {
  count = "${var.create_cloudflare_resources}"

  domain = "startup.com"
  name   = "${var.api_public_subdomain}"
  value  = "${digitalocean_floating_ip.loadbalancers.ip_address}"
  type   = "A"
  ttl    = 300
}

resource cloudflare_record "infrastructure_public_dns" {
  count = "${var.master_infrastructure_env}"

  domain = "startup.com"
  name   = "infrastructure"
  value  = "${digitalocean_floating_ip.loadbalancers.ip_address}"
  type   = "A"
  ttl    = 300
}
