resource "linode_instance" "main" {
  label           = var.name
  image           = var.image
  region          = var.region
  type            = var.type
  authorized_keys = var.authorized_keys
  root_pass       = var.root_pass

  group           = var.group
  tags            = var.tags

  connection {
    type        = "ssh"
    user        = "root"
    agent       = "false"
    password    = var.root_pass
    private_key = var.private_key
    host        = self.ip_address
  }

  provisioner "file" {
    source      = "${path.module}/config"
    destination = "/tmp"
  }

  provisioner "file" {
    source      = "${path.module}/scripts"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 755 /tmp/scripts/*.sh",
      "mv /tmp/scripts/*.sh /usr/local/bin/",
      "/usr/local/bin/install_docker.sh",
      "/usr/local/bin/install_fail2ban.sh",
      "mv /tmp/config/* /data/",
      "ACME_EMAIL=\"${var.acme_email}\" TRAEFIK_ADMIN_HTPASSWORD=\"${var.traefik_admin_htpassword}\" TRAEFIK_ADMIN_USERNAME=\"${var.traefik_admin_username}\" /usr/local/bin/deploy.sh"
    ]
  }
}
