resource digitalocean_tag "primary_db_server" {
  name = "primary-db-server-${var.env_slug}"
}

# -------------------------------- Platform non-dedicated shards (primaries) --------------------------------

## Blue

resource digitalocean_droplet "primary_db_servers_blue" {
  name = "primary-db0${count.index}.${var.dns_zone}"

  size               = "${var.primary_db_servers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "1"
  tags               = [
    "${digitalocean_tag.internal_access_only.id}",
    "${digitalocean_tag.primary_db_server.id}"
  ]

  count = "${var.primary_db_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "primary-db0${count.index}.${var.dns_zone}")}"
}

resource powerdns_record "primary_db_servers_blue" {
  count = "${var.primary_db_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "primary-db0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.primary_db_servers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}


# -------------------------------- Platform dedicated shards (primaries) --------------------------------

## Blue

resource digitalocean_droplet "primary_db_dedicated_servers_blue" {
  name = "primary-db-d${count.index + 1}b.${var.dns_zone}"

  size               = "${var.primary_db_dedicated_servers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "1"
  tags               = [
    "${digitalocean_tag.internal_access_only.id}",
    "${digitalocean_tag.primary_db_server.id}"
  ]

  count = "${var.primary_db_dedicated_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "primary-db-d${count.index + 1}b.${var.dns_zone}")}"
}

resource powerdns_record "primary_db_dedicated_servers_blue" {
  count = "${var.primary_db_dedicated_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "primary-db-d${count.index + 1}b.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.primary_db_dedicated_servers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}
