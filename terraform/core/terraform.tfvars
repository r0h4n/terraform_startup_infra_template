env_slug = "core"
env_name = "Core"
dns_zone = "core.sgp1.startup.com"
api_public_subdomain = "zzzzz"

create_cloudflare_resources = 0

base_image_id = "you_startup_base_image_id" # Ubuntu 18.04

# CHANGE THESE IP's TO ACTUALS---------------------------------------------------------------------------
salt_master_ip = "8.8.8.8"
internal_dns_ip = "8.8.8.8"


# Servers
vpn_servers = { count = 1 }
vpn_ca_servers = { count = 1 }
saltmasters = { count = 1, size = "s-1vcpu-2gb" }
nameservers = { count = 1, size = "s-1vcpu-2gb" }

metrics_servers_blue = { count = 1, size = "s-2vcpu-4gb" }
sensu_servers_blue = { count = 1, size = "s-2vcpu-2gb" }
