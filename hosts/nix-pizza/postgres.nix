{ config, ... }: {
  services.postgresql = {
    enable = true;
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
