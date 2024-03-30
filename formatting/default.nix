{ inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = { config, ... }: {
    treefmt.config = {
      inherit (config.flake-root) projectRootFile;
      programs = {
        nixpkgs-fmt.enable = true;
        deadnix.enable = true;
        shellcheck.enable = true;
        statix.enable = true;
      };
    };
  };

}
