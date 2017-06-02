output "manager_ip" {
  value = "${digitalocean_droplet.docker_swarm_manager.ipv4_address_private}"
}
