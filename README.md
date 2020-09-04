# terraform-crawl-linode

Deploy a DCSS server in Linode

# Requirements

* a Linode account.
* the `linode.ssh_key` resource is handled elsewhere.

# Usage

To use this module, in your `main.tf` TerraForm code for a deployment insert the following:

``` code
module "crawl" {
  source = "github.com/frozenfoxx/terraform-crawl-linode"

  authorized_keys          = ["${linode_sshkey.terraform.ssh_key}"]
  fqdn                     = var.fqdn
  image                    = var.image
  name                     = "crawl"
  private_key              = chomp(file(var.private_ssh_key))
  region                   = var.region
  traefik_acme_email       = var.traefik_acme_email
  type                     = var.type
}
```
