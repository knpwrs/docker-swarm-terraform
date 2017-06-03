provider "digitalocean" {
  token = "${var.do_token}"
}

data "external" "swarm_join_token" {
  program = ["./get-join-tokens.sh"]
  query = {
    private_key_path = "${var.private_key_path}"
    host = "${digitalocean_droplet.docker_swarm_manager.ipv4_address}"
  }
}

resource "digitalocean_ssh_key" "default" {
  name = "${var.do_key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "digitalocean_tag" "docker_swarm_public" {
  name = "docker-swarm-public"
}

resource "digitalocean_droplet" "docker_swarm_manager" {
  name = "docker-swarm-manager"
  tags = ["${digitalocean_tag.docker_swarm_public.id}"]
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
  count = 3
  name = "docker-swarm-worker-${count.index}"
  tags = ["${digitalocean_tag.docker_swarm_public.id}"]
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
      "docker swarm join --token ${data.external.swarm_join_token.result.worker} ${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}:2377"
    ]
  }
}

resource "digitalocean_loadbalancer" "public" {
  name = "docker-swarm-public-loadbalancer"
  region = "${var.do_region}"
  droplet_tag = "${digitalocean_tag.docker_swarm_public.name}"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"
    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }
}
