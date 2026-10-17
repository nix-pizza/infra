variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_account_id" {
  type      = string
  sensitive = true
}

variable "cloudflare_dns_token" {
  type      = string
  sensitive = true
}

variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "ssh_public_keys" {
  type = string
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token with admin:org scope."
  sensitive   = true
}

variable "github_members" {
  type        = string
  description = "Path to a JSON file mapping GitHub usernames to their organization role."
}
