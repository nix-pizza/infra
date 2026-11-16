topArgs: {
  perSystem =
    { config
    , pkgs
    , ...
    }: {
      packages = {
        inject-secrets = config.agenix-shell.installationScript;
        inherit (pkgs) opentofu;
        nix-milano = topArgs.config.flake.nixosConfigurations.nix-pizza.config.services.nginx.virtualHosts."milano.nix.pizza".locations."/".root;
      };
    };
}
