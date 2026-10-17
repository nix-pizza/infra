topArgs@{ lib, ... }: {
  options.infra.sshKeys = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({ config, ... }: {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = config._module.args.name;
          description = "SSH public key owner";
        };
        key = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "SSH public key";
        };
        terraform = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Append the key to the `ssh_public_keys` variable in Terraform";
        };
        githubRole = lib.mkOption {
          type = lib.types.nullOr (lib.types.enum [ "admin" "member" ]);
          default = null;
          description = ''
            Role in the nix-pizza GitHub organization, applied by Terraform through the
            `github_members` variable. The attribute name is the GitHub username.
            `null` means no organization membership is managed for this entry.
          '';
        };
      };
    }));
    default = { };
    description = "SSH keys and GitHub memberships";
  };

  config.perSystem = { config, pkgs, ... }: {
    packages = {
      ssh-public-keys =
        let
          keys = lib.filterAttrs (_: key: key.terraform && key.key != null) topArgs.config.infra.sshKeys;
        in
        pkgs.writers.writeJSON "ssh_public_keys.json" (lib.mapAttrs (_: key: key.key) keys);
      github-members =
        let
          members = lib.filterAttrs (_: key: key.githubRole != null) topArgs.config.infra.sshKeys;
        in
        pkgs.writers.writeJSON "github_members.json" (lib.mapAttrs (_: key: key.githubRole) members);
    };
    devshells.default.env = [
      {
        name = "TF_VAR_ssh_public_keys";
        value = config.packages.ssh-public-keys;
      }
      {
        name = "TF_VAR_github_members";
        value = config.packages.github-members;
      }
    ];
  };

}
