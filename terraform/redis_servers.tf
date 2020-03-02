resource digitalocean_droplet "redis_servers_blue" {
  name = "redis0${count.index}.${var.dns_zone}"

  size               = "${var.redis_servers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "true"
  tags               = [
    "${digitalocean_tag.internal_access_only.id}",

  ]

  count = "${var.redis_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "redis0${count.index}.${var.dns_zone}")}"
}

resource powerdns_record "redis_servers_blue" {
  count = "${var.redis_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "redis0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.redis_servers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}
