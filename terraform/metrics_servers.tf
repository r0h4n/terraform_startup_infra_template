resource digitalocean_droplet "metrics_servers_blue" {
  name = "metrics0${count.index}.${var.dns_zone}"

  size               = "${var.metrics_servers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "true"

  count = "${var.metrics_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${data.template_file.cloud_config_ubuntu_bionic.rendered}"
}

resource powerdns_record "metrics_servers_blue" {
  count = "${var.metrics_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "metrics0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.metrics_servers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}
