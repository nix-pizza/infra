{
  perSystem = { config, ... }: {
    packages.inject-secrets = config.agenix-shell.installationScript;
  };
}
