env_slug = "beta"
env_name = "Beta"
dns_zone = "beta.sgp1.startup.com"
api_public_subdomain = "api-beta"

create_cloudflare_resources = 1

base_image_id = "you_startup_base_image_id" # Ubuntu 18.04

# CHANGE THESE IP's TO ACTUALS---------------------------------------------------------------------------
salt_master_ip = "8.8.8.8"
internal_dns_ip = "8.8.8.8"



primary_db_servers_blue = { count = 0 }
redis_servers_blue = { count = 0 }
replica_db_servers_blue = { count = 0 }


cache_servers_blue = { count = 0 }

loadbalancers_blue = { count = 1 }
mq_servers_blue = { count = 0 }


