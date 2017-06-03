provider "digitalocean" {
  token = "${var.do_token}"
}

data "external" "swarm_worker_token" {
  program = ["./get-worker-join-token.sh"]
  query = {
    private_key_path = "${var.private_key_path}"
    host = "${digitalocean_droplet.docker_swarm_manager.ipv4_address}"
  }
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
  private_networking = true

  provisioner "remote-exec" {
    script = "install-docker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertise-addr ${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}"
    ]
  }
}

resource "digitalocean_droplet" "docker_swarm_worker" {
  name = "docker-swarm-worker"
  region = "${var.do_region}"
  size = "${var.do_droplet_size}"
  image = "${var.do_image}"
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
  private_networking = true

  provisioner "remote-exec" {
    script = "install-docker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "docker swarm join --token ${data.external.swarm_worker_token.result.token} ${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}:2377"
    ]
  }
}
