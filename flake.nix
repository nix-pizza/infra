{
  description = "Infrastructure flake for nix.pizza";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.url = "github:numtide/devshell";
    flake-root.url = "github:srid/flake-root";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.devshell.flakeModule
        ./terraform.nix
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];

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
    };
}
