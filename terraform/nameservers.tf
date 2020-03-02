resource digitalocean_droplet "nameservers" {
  name = "ns0${count.index}.${var.env_slug}.${var.digital_ocean_region}.startup.com"

  size               = "${var.nameservers["size"]}"
  region             = "${var.digital_ocean_region}"
  private_networking = "true"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  image              = "${var.base_image_id}"

  count = "${var.nameservers["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${data.template_file.cloud_config_ubuntu_bionic.rendered}"
}

resource "powerdns_record" "zone_soa_record" {
  count = "${var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "${local.dns_zone_canonical}"
  type    = "SOA"
  ttl     = 3600
  records = ["ns00.${local.dns_zone_canonical} hostmaster.sgp1.startup.com. 1 10800 3600 604800 300"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "powerdns_record" "nameservers" {
  count = "${var.nameservers["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "ns0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.nameservers.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}
