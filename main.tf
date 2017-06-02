provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "default" {
  name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "digitalocean_droplet" "docker_swarm_manager" {
  name = "docker-swarm-manager"
  region = "${var.do_region}"
  size = "${var.do_droplet_size}"
  image = "${var.do_image}"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]

  provisioner "remote-exec" {
    script = "install-docker.sh"
  }
}
