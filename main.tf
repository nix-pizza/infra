# TODO split this messy file into different files and/or refactor using modules

terraform {
  backend "s3" {
    bucket = "nix-pizza-terraform-state"
    key    = "terraform.tfstate"

    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "cloudflare" {
  alias     = "dns"
  api_token = var.cloudflare_dns_token
}

resource "cloudflare_r2_bucket" "cloudflare-bucket" {
  account_id = var.cloudflare_account_id
  name       = "nix-pizza-terraform-state"
  location   = "WEUR"
}

provider "hcloud" {
  token = var.hcloud_token
}

locals {
  ssh_public_keys = jsondecode(file(var.ssh_public_keys))
}

resource "hcloud_ssh_key" "ssh_public_keys" {
  name       = "hcloud_ssh_key-${each.key}"
  for_each   = local.ssh_public_keys
  public_key = each.value
}

resource "hcloud_server" "nix-pizza" {
  name        = "nix-pizza"
  image       = "debian-11" # used only for the initial bootstrapping
  server_type = "cax11"
  location    = "fsn1"
  ssh_keys    = [for _, v in hcloud_ssh_key.ssh_public_keys : v.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  lifecycle {
    ignore_changes = [
      ssh_keys
    ]
  }
}

module "deploy" {
  source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nixos_system_attr      = ".#nixosConfigurations.nix-pizza.config.system.build.toplevel"
  nixos_partitioner_attr = ".#nixosConfigurations.nix-pizza.config.system.build.diskoScript"

  target_host = hcloud_server.nix-pizza.ipv4_address
  instance_id = hcloud_server.nix-pizza.id
}


data "cloudflare_zone" "nix_pizza_zone" {
  provider = cloudflare.dns
  name     = "nix.pizza"
}

resource "cloudflare_record" "root_record_4" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  name     = "root"
  value    = hcloud_server.nix-pizza.ipv4_address
  type     = "A"
  ttl      = 300
}

resource "cloudflare_record" "root_record_6" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  name     = "root"
  value    = hcloud_server.nix-pizza.ipv6_address
  type     = "AAAA"
  ttl      = 300
}

resource "cloudflare_record" "wildcard_record_4" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  name     = "*"
  value    = hcloud_server.nix-pizza.ipv4_address
  type     = "A"
  ttl      = 300
}


resource "cloudflare_record" "wildcard_record_6" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  name     = "*"
  value    = hcloud_server.nix-pizza.ipv6_address
  type     = "AAAA"
  ttl      = 300
}
