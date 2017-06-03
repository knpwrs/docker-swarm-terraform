output "manager_public_ip" {
  value = "${digitalocean_droplet.docker_swarm_manager.ipv4_address}"
}

output "manager_private_ip" {
  value = "${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}"
}

output "loadbalancer_public_ip" {
  value = "${digitalocean_loadbalancer.public.ip}"
}

output "private_key_path" {
  value = "${var.private_key_path}"
}
