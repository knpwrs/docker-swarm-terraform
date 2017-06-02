output "master_ip" {
  value = "${digitalocean_droplet.docker_swarm_master.ipv4_address_private}"
}
