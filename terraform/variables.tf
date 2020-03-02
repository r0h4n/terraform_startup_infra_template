# These are read from the TF_VAR_xxx envvars, but still need to be defined here.
variable "digitalocean_api_token" {}

variable "cloudflare_token" {}

variable "cloudflare_email" {
  default = "jesus@startup.com"
}

variable "create_cloudflare_resources" {
  default = 0
}


variable "master_infrastructure_env" {
  default = 0
}

# The DigitalOcean data center which we're operating in.
variable "digital_ocean_region" {
  default = "sgp1"
}

# Id of the base digitalocean image.
variable "base_image_id" {}

# DNS zone = e.g. prd.sgp1.startup.com
variable "dns_zone" {}

# PowerDNS
# When bootstrapping, this will need to be set to 0.
variable "create_dns" {
  default = "1"
}

variable "pdns_api_key" {}
variable "pdns_server_url" {}

# Environment specific variables.
variable "env_slug" {}

variable "env_name" {}

variable "api_public_subdomain" {
  default = "test-api"
}

variable "salt_master_ip" {}
variable "internal_dns_ip" {}

variable "internal_dns_ttl" {
  default = 86400
}

# Role specific variables
variable "vpn_servers" {
  default = {
    count = 0
    size  = "s-1vcpu-1gb"
  }
}

variable "vpn_ca_servers" {
  default = {
    count = 0
    size  = "s-1vcpu-1gb"
  }
}

variable "nameservers" {
  default = {
    count = 0
    size  = "1gb"
  }
}

variable "saltmasters" {
  default = {
    count = 0
    size  = "1gb"
  }
}

variable "metrics_servers_blue" {
  default = {
    count = 0
    size  = "4gb"
  }
}


variable "cache_servers_blue" {
  default = {
    count = 0
    size  = "s-1vcpu-2gb"
  }
}


variable "loadbalancers_blue" {
  default = {
    count = 0
    size  = "s-1vcpu-2gb"
  }
}


variable "mq_servers_blue" {
  default = {
    count = 0
    size  = "s-1vcpu-2gb"
  }
}


variable "primary_db_servers_blue" {
  default = {
    count = 0
    size  = "s-2vcpu-4gb"
  }
}

variable "primary_db_dedicated_servers_blue" {
  default = {
    count = 0
    size  = "s-4vcpu-8gb"
  }
}


variable "replica_db_servers_blue" {
  default = {
    count = 0
    size  = "s-2vcpu-4gb"
  }
}


variable "replica_db_dedicated_servers_blue" {
  default = {
    count = 0
    size  = "s-4vcpu-8gb"
  }
}

variable "redis_servers_blue" {
  default = {
    count = 0
    size  = "s-1vcpu-2gb"
  }
}

variable "sensu_servers_blue" {
  default = {
    count = 0
    size  = "1gb"
  }
}


locals {
    dns_zone_canonical = "${var.dns_zone}."
}
