{ inputs, ... }: {
  imports = [
    inputs.flake-root.flakeModule
    inputs.devshell.flakeModule
  ];

  perSystem = { config, pkgs, inputs', ... }: {
    _module.args.pkgs = inputs'.nixpkgs.legacyPackages.extend (final: _: {
      terraform = final.opentofu;
    });
    treefmt.config = {
      programs = {
        terraform.enable = true;
      };
    };
    devshells.default = {
      packages = with pkgs; [
        terraform
        jq # FIXME report upstream: nixos-anywhere terraform module needs it in PATH
      ];
      devshell.startup.terraform-init.text = ''
        	tofu init
      '';
    };
  };
}
