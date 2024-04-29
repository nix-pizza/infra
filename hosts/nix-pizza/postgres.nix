{ config, ... }: {
  services.postgresql = {
    enable = true;
  };

  services.postgresqlBackup = {
    enable = true;
    backupAll = true;
  };

  environment.persistence."/persist".directories = [
    config.services.postgresql.dataDir
    config.services.postgresqlBackup.location
  ];
}
