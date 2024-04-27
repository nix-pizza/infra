{
  perSystem = { config, pkgs, ... }: {
    packages = {
      inject-secrets = config.agenix-shell.installationScript;
      inherit (pkgs) opentofu;
    };
  };
}
