topArgs: {
  perSystem = { config, pkgs, lib, system, ... }: {
    packages = {
      inject-secrets = config.agenix-shell.installationScript;
      inherit (pkgs) opentofu;
    } // lib.optionalAttrs (system == "aarch64-linux") {
      nix-milano = topArgs.config.flake.nixosConfigurations.nix-pizza.config.services.nginx.virtualHosts."milano.nix.pizza".locations."/".root;
    };
  };
}
