provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}
