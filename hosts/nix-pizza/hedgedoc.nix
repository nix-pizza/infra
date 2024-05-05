{ config, ... }:
let
  cfg = config.services.hedgedoc;
in
{
  services.nginx = {
    virtualHosts."${cfg.settings.domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://${cfg.settings.host}:${builtins.toString cfg.settings.port}";
    };
  };

  services.postgresql = {
    ensureDatabases = [ cfg.settings.db.database ];
    ensureUsers = [
      {
        name = cfg.settings.db.username;
        ensureDBOwnership = true;
      }
    ];
  };

  # Contains the environment variables for the GitHub OAuth2 app
  # https://github.com/settings/applications/2562220
  age.secrets.HEDGEDOC_ENVIRONMENT = {
    file = ../../secrets/HEDGEDOC_ENVIRONMENT.age;
    owner = "hedgedoc";
    group = "hedgedoc";
  };

  services.hedgedoc = {
    enable = true;
    settings = {
      domain = "margherita.nix.pizza";
      host = "localhost";
      port = 3000;
      allowGravatar = true;
      protocolUseSSL = true;
      db = {
        username = "hedgedoc";
        database = "hedgedoc";
        host = "/run/postgresql";
        dialect = "postgresql";
      };
      uploadPath = "/var/lib/hedgehog/uploads";
    };
    environmentFile = config.age.secrets.HEDGEDOC_ENVIRONMENT.path;
  };

  environment.persistence."/persist".directories = [
    cfg.settings.uploadPath
  ];
}
