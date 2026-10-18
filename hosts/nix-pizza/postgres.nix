{ config, pkgs, ... }: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
  };

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
    location = "/var/backup/postgresql";
  };

  environment.persistence."/persist".directories = [
    config.services.postgresql.dataDir
    config.services.postgresqlBackup.location
  ];
}
