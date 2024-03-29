{
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
      packages = [ pkgs.terraform ];
    };
  };
}
