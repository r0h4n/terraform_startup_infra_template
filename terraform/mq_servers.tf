## Blue

resource digitalocean_droplet "mq_servers_blue" {
  name = "mq0${count.index}.${var.dns_zone}"

  size               = "${var.mq_servers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "true"

  count = "${var.mq_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "mq0${count.index}.${var.dns_zone}")}"
}

resource powerdns_record "mq_servers_blue" {
  count = "${var.mq_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "mq0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.mq_servers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}
