{ config, ... }:
let
  cfg = config.mailserver;
in
{
  mailserver = {
    enable = true;
    fqdn = "mail.nix.pizza";
    domains = [ "nix.pizza" ];

    # nix run nixpkgs#mkpasswd -- -sm bcrypt
    loginAccounts = {
      "aciceri@nix.pizza".hashedPassword = "$2b$05$SHmYA8c9Nxx8A7dbqdsInugMNWd5mZydtC485VEbQ9NtoWJ2qUNCC"; 
      "zarel@nix.pizza".hashedPassword = "$2b$05$QkTJbKhMdJlaZq3QvNNg5O3kXuWzjLRlTj.yjfxp5Bl7.dqaMmOka"; # TODO
      "albertodvp@nix.pizza".hashedPassword = "$2b$05$2SD6.tz4CZ7n7amcL9LLzua/vDbM3..laGAGYXylM94m9l4EMzLlW";
    };

    extraVirtualAliases =
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

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };

  services.roundcube = {
    enable = true;
    hostName = "webmail.nix.pizza";
    extraConfig = ''
      # starttls needed for authentication, so the fqdn required to match
      # the certificate
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
  };

  environment.persistence."/persist".directories = [
    cfg.mailDirectory
    cfg.certificateDirectory
    cfg.dkimKeyDirectory
  ];
}
