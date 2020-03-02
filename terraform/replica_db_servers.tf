resource digitalocean_tag "replica_db_server" {
  name = "replica-db-server-${var.env_slug}"
}

# -------------------------------- Platform non-dedicated shards (replicas) --------------------------------

## Blue (you can add "Green" deployment)

resource digitalocean_droplet "replica_db_servers_blue" {
  name = "replica-db0${count.index}.${var.dns_zone}"

  size               = "${var.replica_db_servers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "true"
  tags               = [
    "${digitalocean_tag.internal_access_only.id}",
    "${digitalocean_tag.replica_db_server.id}"
  ]

  count = "${var.replica_db_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${format(data.template_file.cloud_config_ubuntu_bionic.rendered, "replica-db0${count.index}.${var.dns_zone}")}"
}

resource powerdns_record "replica_db_servers_blue" {
  count = "${var.replica_db_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "replica-db0${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.replica_db_servers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}



# -------------------------------- Platform dedicated shards (replicas) --------------------------------

resource digitalocean_droplet "replica_db_dedicated_servers_blue" {
  name = "replica-db-D${count.index + 1}.${var.env_slug}.${var.digital_ocean_region}.startup.com"

  size               = "${var.replica_db_dedicated_servers_blue["size"]}"
  image              = "${var.base_image_id}"
  ssh_keys           = ["${digitalocean_ssh_key.bootstrap.id}"]
  region             = "${var.digital_ocean_region}"
  private_networking = "true"
  tags               = [
    "${digitalocean_tag.internal_access_only.id}",
    "${digitalocean_tag.replica_db_server.id}"
  ]

  count = "${var.replica_db_dedicated_servers_blue["count"]}"

  lifecycle {
    ignore_changes = ["user_data", "image"]
  }

  user_data = "${data.template_file.cloud_config_ubuntu_bionic.rendered}"
}

resource powerdns_record "replica_db_dedicated_servers_blue" {
  count = "${var.replica_db_dedicated_servers_blue["count"] * var.create_dns}"

  zone    = "${var.dns_zone}"
  name    = "replica-db-D${count.index}.${local.dns_zone_canonical}"
  type    = "A"
  ttl     = "${var.internal_dns_ttl}"
  records = ["${element(digitalocean_droplet.replica_db_dedicated_servers_blue.*.ipv4_address_private, count.index)}"]

  lifecycle {
    create_before_destroy = true
  }
}
