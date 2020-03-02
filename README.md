# Startup Infrastructure
Opinionated quick start configuration and provisioning information for a technology
startup's infrastructure.

## Getting Started
To begin, install the required software. Terraform version
[0.11.0](https://releases.hashicorp.com/terraform/) is
required.

```
brew install terraform
brew install packer
```

Terraform operations are managed with the `startup_ops` executable,
for passing the configuration and state to Terraform so
that it can operate on multiple environments independently.


## Supplying credentials
**Credentials to modify your Startup's infrastructure
are amongst the most important to the business. They must be treated with extreme
care, and all care should be taken to ensure they are never compromised.**

In order to store credentials securely on your local machine, install [envchain](https://github.com/sorah/envchain).
This will keep your API keys securely in your KeyChain, and `envchain` will be
automatically invoked by `startup_ops`.

```
$ brew install envchain

$ envchain --set startup TF_VAR_digitalocean_api_token
startup.TF_VAR_digitalocean_api_token: { Paste your API token here }

$ envchain --set startup DIGITALOCEAN_API_TOKEN
startup.DIGITALOCEAN_API_TOKEN: { Paste your API token here again }

$ envchain --set startup TF_VAR_cloudflare_token
startup.TF_VAR_cloudflare_token: { Paste the Cloudflare API token here}

$ envchain --set startup AWS_ACCESS_KEY_ID
startup.AWS_ACCESS_KEY_ID: { Paste your AWS Access Key here}

$ envchain --set startup AWS_SECRET_ACCESS_KEY
startup.AWS_SECRET_ACCESS_KEY: { Paste your AWS Secret Key here }
```

Keep all the credentials in a single `startup` namespace so that we can
provide them all at once to Terraform.


## Test environment
DigitalOcean account for your Startup which can be used to test the
infrastructure in a segregated environment different from production. This
is the `test` environment, and can be configured in a separate `envchain`
namespace as follows:

```
$ envchain --set startup_test TF_VAR_digitalocean_api_token
startup.TF_VAR_digitalocean_api_token: { Paste your API token here }

$ envchain --set startup_test DIGITALOCEAN_API_TOKEN
startup.DIGITALOCEAN_API_TOKEN: { Paste your API token here again }

$ envchain --set startup_test AWS_ACCESS_KEY_ID
startup.AWS_ACCESS_KEY_ID: { Paste your AWS Access Key here}

$ envchain --set startup_test AWS_SECRET_ACCESS_KEY
startup.AWS_SECRET_ACCESS_KEY: { Paste your AWS Secret Key here }
```

This envchain namespace will be automatically used when the 'test' environment
is used.

## Terraform remote state
Terraform keeps its remote state in S3. The script will automatically select the correct
state configuration for you prior to running any command.

## Terraform Plan
Terraform's `plan` command runs a diff between the current state of the
infrastructure as described by the providers' APIs, and the
desired state describe in the various `.tf` files.

Run `startup_ops {environment} plan` immediately before running Terraform
apply.

## Terraform Apply
Terraforms's `apply` command applies the desired infrastructure description to
the infrastructure.

Run `startup_ops {environment} apply` to apply the new Terraform state.

# TODO
Describe each environment
