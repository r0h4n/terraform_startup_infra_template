provider "digitalocean" {
  token = "${var.digitalocean_api_token}"
}

provider "powerdns" {
  api_key    = "${var.pdns_api_key}"
  server_url = "${var.pdns_server_url}"
}

provider "cloudflare" {
  version = "~> 0.1"
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}
