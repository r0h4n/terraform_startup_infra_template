data "template_file" "cloud_config_ubuntu_bionic" {
  template = "${file("./templates/cloud_config_ubuntu_bionic")}"

  vars {
    env_slug        = "${var.env_slug}"
    saltmaster_ip   = "${var.salt_master_ip}"
    internal_dns_ip = "${var.internal_dns_ip}"
  }
}
