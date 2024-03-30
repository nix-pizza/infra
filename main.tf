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

resource "cloudflare_r2_bucket" "cloudflare-bucket" {
  account_id = var.cloudflare_account_id
  name       = "nix-pizza-terraform-state"
  location   = "WEUR"
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "aciceri" {
  name       = "aciceri"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzCmDCtlGscpesHuoiruVWD2IjYEFtaIl9Y2JZGiOAyf3V17KPx0MikcknfmxSHi399SxppiaXQHxo/1wjGxXkXNTTv6h1fBuqwhJE6C8+ZSV+gal81vEnXX+/9w2FQqtVgnG2/mO7oJ0e3FY+6kFpOsGEhYexoGt/UxIpAZoqIN+CWNhJIASUkneaZWtgwiL8Afb59kJQ2E7WbBu+PjYZ/s5lhPobhlkz6s8rkhItvYdiSHT0DPDKvp1oEbxsxd4E4cjJFbahyS8b089NJd9gF5gs0b74H/2lUUymnl63cV37Mp4iXB4rtE69MbjqsGEBKTPumLualmc8pOGBHqWIdhAqGdZQeBajcb6VK0E3hcU0wBB+GJgm7KUzlAHGdC3azY0KlHMrLaZN0pBrgCVR6zBNWtZz2B2qMBZ8Cw+K4vut8GuspdXZscID10U578GxQvJAB9CdxNUtrzSmKX2UtZPB1udWjjIAlejzba4MG73uXgQEdv0NcuHNwaLuCWxTUT5QQF18IwlJ23Mg8aPK8ojUW5A+kGHAu9wtgZVcX1nS5cmYKSgLzcP1LA1l9fTJ1vqBSuy38GTdUzfzz7AbnkRfGPj2ALDgyx17Rc5ommjc1k0gFoeIqiLaxEs5FzDcRyo7YvZXPsGeIqNCYwQWw3+U+yUEJby8bxGb2d/6YQ=="
}

resource "hcloud_server" "nix-pizza" {
  name        = "nix-pizza"
  image       = "debian-11"
  server_type = "cax11"
  location    = "fsn1"
  ssh_keys    = [hcloud_ssh_key.aciceri.id] # TODO centralize
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

module "deploy" {
  source = "github.com/nix-community/nixos-anywhere//terraform/all-in-one"

  nixos_system_attr      = ".#nixosConfigurations.nix-pizza.config.system.build.toplevel"
  nixos_partitioner_attr = ".#nixosConfigurations.nix-pizza.config.system.build.diskoScript"

  target_host = hcloud_server.nix-pizza.ipv4_address
  instance_id = hcloud_server.nix-pizza.id
}
