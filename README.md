# Docker Swarm Cluster on Digital Ocean with Terraform

Set up a [Docker Swarm] Cluster on Digital Ocean using Terraform

## WARNING! NOT PRODUCTION READY!

This repository is meant to serve as an example of using Terraform. Basic
security measures such as setting up a firewall, turning off SSH password
access, turning off SSH root access, and creating non-root users are not in
place. Use this repository for learning purposes only, not for setting up a
production [Docker Swarm] deployment.

## Usage

### Preparing [DigitalOcean]

Before getting started, you will need to generate an API token so [Terraform]
can access your [DigitalOcean] account. To generate an API token all you need to
do is log in to your account, click "API" in the top navigation bar, and then
click "Generate New Token." Give the token a name and make sure you enable read
and write access. Copy down the API token and keep it somewhere safe --
[DigitalOcean] will not show you the token again. If you lose the token you will
have to generate a new one.

### Generate a Public/Private Key-Pair

Use the following command to generate a public and private key-pair:

```sh
ssh-keygen -o -a 100 -t ed25519 -C dockerswarm@digitalocean
```

By default this will create two files: `~/.ssh/id_ed25519` and
`~/.ssh/id_ed25519.pub`. When the command runs you will have an opportunity to
use a different location if you want. Make sure you use a strong passphrase when
generating the key. Once the keys are generated use the following command to add
the private key to your SSH agent:

```sh
ssh-add ~/.ssh/id_ed25519
```

### Create a [Terraform] Variables File

Create a file in this repository named `terraform.tfvars` with contents as such:

```
do_token="DIGITALOCEAN API TOKEN"
public_key_path="~/.ssh/id_ed25519.pub"
```

Replace `DIGITALOCEAN API TOKEN` with your actual API token and
`~/.ssh/id_ed25519` with the path to your public key.

### Spin Up Infrastructure

Run the following command to see what changes `terraform` will make to your
[DigitalOcean] account:

```sh
terraform plan
```

If everything looks good, go ahead and run:

```sh
terraform apply
```

Congratulations! You know have a functioning four-node [Docker Swarm] cluster!

## More Information

See [my accompanying blog post][blog] for more information, including how to
deploy services and how to scale the swarm.

## License

MIT

[DigitalOcean]: https://m.do.co/c/41b1b93b4c2d "$10 Free Credit on DigitalOcean"
[Docker Swarm]: https://docs.docker.com/engine/swarm/ "Docker Swarm"
[Terraform]: https://www.terraform.io/ "Terraform"
[blog]: http://knpw.rs/blog/docker-swarm-terraform "Creating and Scaling a Docker Swarm Cluster with Terraform"
