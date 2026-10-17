<p align="center">
  <img src="./hosts/nix-pizza/nix-milano/artwork/nix-milano.svg" alt="Nix Milano Logo" width="600"/>
</p>

# Infra

Infrastructure as code for [nix.pizza](https://nix.pizza) and the [nix-pizza](https://github.com/nix-pizza) GitHub organization, which also hosts the [Nix Milano](https://milano.nix.pizza) community.

## What's inside

- `main.tf`, `mail.tf`: Hetzner server, Cloudflare DNS, deployment with nixos-anywhere.
- `github.tf`: GitHub organization settings, memberships, the `infra` repository and its branch ruleset.
- `keys/`: SSH keys and GitHub roles of the people involved. One entry per person; `githubRole` grants organization membership, `terraform = true` uploads the key to Hetzner.
- `hosts/`: NixOS configuration of the `nix-pizza` host (mail, HedgeDoc, wastebin, static sites).
- `secrets/`: agenix secrets. Those readable by the CI key are exposed as environment variables in the dev shell and in GitHub Actions; the credentials of the `ambrogio-bot` account are readable by its owners only.

## Workflow

- Every pull request runs `nix flake check` and `tofu plan`; the plan is in the job log.
- Pushes to `main` run `tofu apply` and deploy the host.
- The GitHub provider authenticates as `ambrogio-bot`, an owner of the organization, with a classic personal access token (`admin:org`).

## Adding a member

Add an entry to `keys/default.nix` whose attribute name is the GitHub username and set `githubRole` to `member` or `admin`. On apply GitHub sends an invitation that the person has to accept.

## Local development

`direnv allow` or `nix develop`. The shell decrypts the secrets you have access to and runs `tofu init`. The state lives in a Cloudflare R2 bucket, so the `AWS_*` secrets are required for any OpenTofu command.
