{
  perSystem = {config, pkgs, lib, ...}: {
    packages.inject-secrets = config.agenix-shell.installationScript;
  };
}
