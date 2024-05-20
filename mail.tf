resource "hcloud_rdns" "reverse_dns_4" {
  server_id  = hcloud_server.nix-pizza.id
  ip_address = hcloud_server.nix-pizza.ipv4_address
  dns_ptr    = "mail.nix.pizza"
}

resource "cloudflare_record" "mail_record_4" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  name     = "mail.nix.pizza"
  value    = hcloud_server.nix-pizza.ipv4_address
  type     = "A"
  ttl      = 10800
}

resource "cloudflare_record" "mx_record_4" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  type     = "MX"
  name     = "@"
  value    = "mail.nix.pizza"
  priority = 10
  proxied  = false
  ttl      = 300
}

resource "cloudflare_record" "spf_record" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  name     = "nix.pizza"
  proxied  = false
  ttl      = 10800
  type     = "TXT"
  value    = "v=spf1 a:mail.nix.pizza ~all"
}

# cat /var/dkim/nix.pizza.mail.txt
resource "cloudflare_record" "dkim_record" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  name     = "mail._domainkey.nix.pizza"
  value    = "v=DKIM1; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC1fmBfXdR6HV/sHziAej0AtrZSgBSvanZfXs8NjfmjzxBtBUTeqxsBY761iPYiLmHZiRdi7H6DetXNSKo3ivfW8X66VVqjSSLMx75NDLauauDMP+sfYbA8nQTZjsoigOgPelGsBym2TlE/I1SgG7L0a3f5DEVGynQ6AYIYFhLUewIDAQAB"
  type     = "TXT"
  ttl      = 10800
}

resource "cloudflare_record" "dmarc_record" {
  provider = cloudflare.dns
  zone_id  = data.cloudflare_zone.nix_pizza_zone.id
  name     = "_dmarc"
  value    = "v=DMARC1; p=reject; pct=100"
  type     = "TXT"
  ttl      = 10800
}
