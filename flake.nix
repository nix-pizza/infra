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
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      ./keys
      ./shell
      ./hosts
      ./formatting
    ];
    systems = [ "x86_64-linux" "aarch64-linux" ];
  };
}
