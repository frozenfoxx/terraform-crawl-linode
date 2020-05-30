variable "authorized_keys" {
  default     = [""]
  description = "List of public keys used for SSH connections"
}

variable "image" {
  default     = "linode/ubuntu18.04"
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

variable "type" {
  default     = "g6-nano-1"
  description = "Type of instance"
}
