# Personal access token (classic, admin:org) of ambrogio-bot, an owner of the organization
provider "github" {
  token = var.github_token
  owner = "nix-pizza"
}

locals {
  github_members = jsondecode(file(var.github_members))
}

import {
  to = github_organization_settings.org
  id = "nix-pizza"
}

resource "github_organization_settings" "org" {
  billing_email             = "info@nix.pizza"
  has_organization_projects = true
  has_repository_projects   = true

  members_can_create_repositories         = true
  members_can_create_public_repositories  = true
  members_can_create_private_repositories = true
  members_can_fork_private_repositories   = false
  members_can_create_pages                = true
  members_can_create_public_pages         = true
  members_can_create_private_pages        = true

  default_repository_permission = "read"
}

# Existing members are imported, the others receive an invitation on apply.
# Static blocks: the OpenTofu in CI predates for_each in import.
import {
  to = github_membership.member["aciceri"]
  id = "nix-pizza:aciceri"
}

import {
  to = github_membership.member["zarelit"]
  id = "nix-pizza:zarelit"
}

import {
  to = github_membership.member["ambrogio-bot"]
  id = "nix-pizza:ambrogio-bot"
}

resource "github_membership" "member" {
  for_each = local.github_members

  username = each.key
  role     = each.value
}

import {
  to = github_repository.infra
  id = "infra"
}

resource "github_repository" "infra" {
  name        = "infra"
  description = "nix.pizza infrastructure"
  visibility  = "public"

  has_issues      = true
  has_projects    = true
  has_wiki        = false
  has_discussions = false

  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  allow_auto_merge       = false
  delete_branch_on_merge = false
}

resource "github_repository_ruleset" "strict-rules" {
  name        = "strict-rules"
  target      = "branch"
  enforcement = "active"
  repository  = github_repository.infra.name

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  rules {
    creation                = true
    deletion                = true
    required_linear_history = true

    branch_name_pattern {
      name     = "Main branch naming rule"
      operator = "regex"
      pattern  = "^main$"
      negate   = false
    }

    commit_message_pattern {
      name     = "No WIP in commit messages"
      operator = "contains"
      pattern  = "WIP"
      negate   = true
    }

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_last_push_approval        = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }
  }

  # Organization owners can always bypass; the provider documents actor_id = 1
  # for this actor type.
  bypass_actors {
    actor_type  = "OrganizationAdmin"
    actor_id    = 1
    bypass_mode = "always"
  }
}
