env_slug = "stg"
env_name = "Staging"
dns_zone = "stg.sgp1.startup.com"
api_public_subdomain = "api-staging"

create_cloudflare_resources = 1

base_image_id = "you_startup_base_image_id" # Ubuntu 18.04

# CHANGE THESE IP's TO ACTUALS---------------------------------------------------------------------------
salt_master_ip = "8.8.8.8"
internal_dns_ip = "8.8.8.8"



primary_db_servers_blue = { count = 0, size = "s-4vcpu-8gb" }
redis_servers_blue = { count = 0 }
replica_db_servers_blue = { count = 0, size = "s-4vcpu-8gb" }



cache_servers_blue = { count = 0, size = "s-1vcpu-3gb" }

loadbalancers_blue = { count = 1, size = "s-2vcpu-2gb" }
mq_servers_blue = { count = 0, size = "s-2vcpu-2gb" }


