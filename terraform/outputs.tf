output "saltmaster_private_ip" {
  value = "${element(concat(digitalocean_droplet.saltmaster.*.ipv4_address_private, list("None")), 0)}"
}

output "vpn_public_ip" {
  value = "${element(concat(digitalocean_droplet.vpn_servers.*.ipv4_address_private, list("None")), 0)}"
}

output "nameserver_private_ip" {
  value = "${element(concat(digitalocean_droplet.nameservers.*.ipv4_address_private, list("None")), 0)}"
}
