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
          type = lib.types.str;
          description = "SSH public key";
        };
        terraform = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Append the key to the `ssh_public_keys` variable in Terraform";
        };
        __toString = lib.mkOption {
          type = lib.types.functionTo lib.types.str;
          internal = true;
          default = self: self.key;
        };
      };
    }));
    default = { };
    description = "SSH keys";
  };

  config.perSystem = { config, pkgs, ... }: {
    packages.ssh-public-keys =
      let
        keys = lib.filterAttrs (_: key: key.terraform) topArgs.config.infra.sshKeys;
      in
      pkgs.writers.writeJSON "ssh_public_keys.json" keys;
    devshells.default.env = [{
      name = "TF_VAR_ssh_public_keys";
      value = config.packages.ssh-public-keys;
    }];
  };

}
