env_slug = "tst"
env_name = "Test"
dns_zone = "tst.sgp1.startup.com"
api_public_subdomain = "api-test"

base_image_id = "you_startup_base_image_id" # Ubuntu 18.04

# CHANGE THESE IP's TO ACTUALS---------------------------------------------------------------------------
salt_master_ip = "8.8.8.8"
internal_dns_ip = "8.8.8.8"

create_dns = 1

saltmasters = { count = 1, size = "s-1vcpu-2gb" }
vpn_servers = { count = 1 }
vpn_ca_servers = { count = 1 }
nameservers = { count = 1, size = "s-1vcpu-2gb" }



metrics_servers_blue = { count = 0, size = "2gb" }
cache_servers_blue = { count = 0, size = "2gb" }


loadbalancers_blue = { count = 0, size = "1gb" }
mq_servers_blue = { count = 0, size = "2gb" }
redis_servers_blue = { count = 0, size = "2gb" }
sensu_servers_blue = { count = 0, size = "1gb" }

