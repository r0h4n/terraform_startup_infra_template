resource digitalocean_droplet "sensuservers_blue" {
  name = "sensu0${count.index}.${var.dns_zone}"

  size               = "${var.sensu_servers_blue["size"]}"
  region             = "${var.digital_ocean_region}"
  private_networking = "true"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  image              = "${var.base_image_id}"

  count = "${var.sensu_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${data.template_file.cloud_config_ubuntu_bionic.rendered}"
}

resource "powerdns_record" "sensuservers_blue" {
  count = "${var.sensu_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "sensu0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.sensuservers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}
