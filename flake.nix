{
  description = "Infrastructure flake for nix.pizza";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.follows = "srvos/nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.url = "github:numtide/devshell";
    flake-root.url = "github:srid/flake-root";
    disko.url = "github:nix-community/disko";
    srvos.url = "github:nix-community/srvos";
    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
    agenix-shell.url = "github:aciceri/agenix-shell";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      ./keys
      ./shell
      ./hosts
      ./formatting
      ./checks
      ./packages
    ];
    systems = [ "x86_64-linux" "aarch64-linux" ];
  };
}
