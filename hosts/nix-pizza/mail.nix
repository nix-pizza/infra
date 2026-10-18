{ config, ... }:
let
  cfg = config.mailserver;
in
{
  mailserver = {
    enable = true;
    stateVersion = 5;
    fqdn = "mail.nix.pizza";
    domains = [ "nix.pizza" ];

    # nix run nixpkgs#mkpasswd -- -sm bcrypt
    accounts = {
      "aciceri@nix.pizza".hashedPassword = "$2b$05$SHmYA8c9Nxx8A7dbqdsInugMNWd5mZydtC485VEbQ9NtoWJ2qUNCC";
      "zarel@nix.pizza".hashedPassword = "$2b$05$XHbxpdM8lRDwyhh.iZiEFe0HVmOutLEZBfCBTKTABb9cCB5QVPrfO";
      "albertodvp@nix.pizza".hashedPassword = "$2b$05$2SD6.tz4CZ7n7amcL9LLzua/vDbM3..laGAGYXylM94m9l4EMzLlW";
      "nonnofelice@nix.pizza".hashedPassword = "$2b$05$kkOTi4r1W3B6N.tee7gpAOHvsItr00LVi.Onv4gaGWRKDSqDAjA5u";
    };

    aliases =
      let
        owners = [
          "aciceri@nix.pizza"
          "zarel@nix.pizza"
        ];
        nix-milano = [
          "aciceri@nix.pizza"
          "albertodvp@nix.pizza"
        ];
      in
      {
        "abuse@nix.pizza" = owners;
        "postmaster@nix.pizza" = owners;
        "milano@nix.pizza" = nix-milano;
        "milan@nix.pizza" = nix-milano;
      };

    forwards = {
      "milano@nix.pizza" = [
        "andrea.ciceri@autistici.org"
        "alberto.fanton@protonmail.com"
      ];
      "milan@nix.pizza" = [
        "andrea.ciceri@autistici.org"
        "alberto.fanton@protonmail.com"
      ];
    };

    x509.useACMEHost = cfg.fqdn;
  };

  services.nginx.virtualHosts.${cfg.fqdn}.enableACME = true;

  services.roundcube = {
    enable = true;
    hostName = "webmail.nix.pizza";
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['smtp_server'] = "tls://${cfg.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  environment.persistence."/persist".directories = [
    cfg.storage.path
    cfg.dkim.keyDirectory
  ];
}
