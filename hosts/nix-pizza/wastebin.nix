{ config, lib, ... }:
let
  cfg = config.services.wastebin;
  host = "marinara.nix.pizza";
  port = 8088;
in
{
  # contains WASTEBIN_PASSWORD_SALT and WASTEBIN_SIGNING_KEY
  age.secrets.WASTEBIN_ENVIRONMENT = {
    file = ../../secrets/WASTEBIN_ENVIRONMENT.age;
    owner = "wastebin";
    group = "wastebin";
  };

  users.groups.wastebin = { };
  users.users.wastebin = {
    description = "Wastebin service user";
    group = "wastebin";
    isSystemUser = true;
  };

  services.wastebin = {
    enable = true;
    stateDir = "/var/lib/wastebin";
    secretFile = config.age.secrets.WASTEBIN_ENVIRONMENT.path;
    settings = {
      WASTEBIN_DATABASE_PATH = "${cfg.stateDir}/sqlite3.db";
      WASTEBIN_BASE_URL = "https://${host}";
      WASTEBIN_ADDRESS_PORT = "127.0.0.1:${builtins.toString port}";
    };
  };

  systemd.services.wastebin.serviceConfig = {
    User = "wastebin";
    Group = "wastebin";
    DynamicUser = lib.mkForce false;
  };

  environment.persistence."/persist".directories = [
    cfg.stateDir
  ];

  services.nginx = {
    virtualHosts."${host}" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://${cfg.settings.WASTEBIN_ADDRESS_PORT}";
    };
  };
}
