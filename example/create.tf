terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

locals {
  keys = [
  ]
}

resource "digitalocean_droplet" "proxy-middlebox" {
  image = "ubuntu-22-04-x64"
  name = "proxy-test-middlebox"
  region = "tor1"
  size = "s-1vcpu-1gb"
  ssh_keys = local.keys
}

resource "digitalocean_droplet" "proxy-forward" {
  image = "ubuntu-22-04-x64"
  name = "proxy-test-forward"
  region = "tor1"
  size = "s-1vcpu-1gb"
  ssh_keys = local.keys
}

resource "digitalocean_project" "remotecollab" {
  name = "remote-collab-proxy"
  description = "Project for proxy for remote collaborators, related to issue neuropoly/computers/issues/631"
  environment = "Staging"
  resources = [digitalocean_droplet.proxy-forward.urn, digitalocean_droplet.proxy-middlebox.urn]
}

resource "local_file" "hosts_cfg" {
  content = templatefile("tf_templates/hosts.tpl",
    {
      proxy-forward-addr = digitalocean_droplet.proxy-forward.ipv4_address
      proxy-middlebox-addr = digitalocean_droplet.proxy-middlebox.ipv4_address
    }
  )
  filename = "hosts"
}
