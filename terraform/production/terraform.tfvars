env_slug = "prd"
env_name = "Production"
dns_zone = "prd.sgp1.startup.com"
api_public_subdomain = "api"

create_cloudflare_resources = 1
master_infrastructure_env = 1

base_image_id = "you_startup_base_image_id" # Ubuntu 18.04

# CHANGE THESE IP's TO ACTUALS---------------------------------------------------------------------------
salt_master_ip = "8.8.8.8"
internal_dns_ip = "8.8.8.8"




primary_db_servers_blue = { count = 5, size = "s-8vcpu-32gb" }
primary_db_dedicated_servers_blue = { count = 0 }
redis_servers_blue = { count = 1, size = "s-4vcpu-8gb" }
replica_db_servers_blue = { count = 0, size = "s-8vcpu-32gb" }


cache_servers_blue = { count = 1, size = "2gb" }

loadbalancers_blue = { count = 1, size = "s-2vcpu-4gb" }
mq_servers_blue = { count = 0, size = "s-2vcpu-4gb" }


