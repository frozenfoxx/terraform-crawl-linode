variable "acme_email" {
  default     = ""
  description = "Email address for Let's Encrypt"
}

variable "authorized_keys" {
  default     = [""]
  description = "List of public keys used for SSH connections"
}

variable "domain" {
  default     = ""
  description = "Domain to attach to for Let's Encrypt and Traefik"
}

variable "image" {
  default     = "linode/ubuntu20.04"
  description = "Image used for deployment"
}

variable "group" {
  default     = "crawl"
  description = "Display group"
}

variable "name" {
  default     = "crawl"
  description = "Hostname of the system"
}

variable "private_key" {
  default     = ""
  description = "Private SSH key for the root user"
}

variable "region" {
  default     = "us-central"
  description = "Region to clone in"
}

variable "root_pass" {
  default     = ""
  description = "Password for the persistent user"
}

variable "tags" {
  default     = [ "games" ]
  description = "Tags to apply"
}

variable "traefik_acme_email" {
  default     = ""
  description = "Email used for Lets Encrypt SSL certificate generation"
}

variable "type" {
  default     = "g6-nanode-1"
  description = "Type of instance"
}
