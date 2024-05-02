{ config, ... }:
let
  nix-pizza-config = config.flake.nixosConfigurations.nix-pizza.config.system.build.toplevel;
in
{
  perSystem = { config, lib, system, ... }: {
    checks = {
      shell = config.devShells.default;
      inherit (config) formatter;
    } // (lib.optionalAttrs (nix-pizza-config.system == system) {
      inherit nix-pizza-config;
    });
  };
}
