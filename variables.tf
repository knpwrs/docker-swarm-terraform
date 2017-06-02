variable "do_token" {
  description = "Your Digital Ocean API token"
}

variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication"
}

variable "key_name" {
  description = "Name of the key on Digital Ocean"
  default = "terraform"
}

variable "do_region" {
  description = "The region slug to launch the Digital Ocean droplets in"
  default = "nyc3"
}

variable "do_droplet_size" {
  description = "The size droplets to use for the master and worker nodes"
  default = "512mb"
}

variable "do_image" {
  description = "The image to use to initialize the droplets"
  default = "ubuntu-16-04-x64"
}
