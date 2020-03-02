resource digitalocean_droplet "cache_servers_blue" {
  name = "cache0${count.index}.${var.dns_zone}"

  size               = "${var.cache_servers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "true"

  count = "${var.cache_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "cache0${count.index}.${var.dns_zone}")}"
}

resource powerdns_record "cache_servers_blue" {
  count = "${var.cache_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "cache0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.cache_servers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}
