<p align="center">
  <img src="./artwork/nix-milano.svg" alt="Nix Milano Logo" width="800"/>
</p>

# Infra

Welcome to the **infra** repository for the [nix-milano](https://github.com/nix-milano) organization!

This repo contains infrastructure as code (IaC) to manage and automate the configuration of our GitHub organization.
We use **Terraform** to declaratively define and version control the state of our GitHub org and its resources.

## 📦 What's inside

- Terraform modules and configs to manage:
  - Teams and team memberships
  - Repository settings and permissions
  - Branch protection rules
  - GitHub Actions permissions
  - Organization-level settings

## 🔒 Security & Permissions

This repo defines sensitive parts of our org. Please treat all access and changes responsibly.
Only authorized maintainers should apply changes to production.

## 🙌 Contributing

If you'd like to contribute to improving our infrastructure setup, feel free to open a PR or start a discussion.
Changes to the infrastructure must be reviewed and approved by org admins.

---

Made with ❤️ by the [Nix Milano](https://github.com/nix-milano) community.
