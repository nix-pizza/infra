{ config, ... }:
let
  cfg = config.mailserver;
in
{
  # age.secrets.MAIL_POSTMASTER_PASSWORD = {
  #   file = ../../secrets/MAIL_POSTMASTER_PASSWORD.age;
  #   owner = "hedgedoc";
  #   group = "hedgedoc";
  # };

  mailserver = {
    enable = true;
    fqdn = "mail.nix.pizza";
    domains = [ "nix.pizza" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "test@nix.pizza" = {
        # hashedPasswordFile = "/a/file/containing/a/hashed/password";
        hashedPassword = "$2b$05$QkTJbKhMdJlaZq3QvNNg5O3kXuWzjLRlTj.yjfxp5Bl7.dqaMmOka";
        aliases = [ "" ];
      };
      "aciceri@nix.pizza" = {
        hashedPassword = "$2b$05$QkTJbKhMdJlaZq3QvNNg5O3kXuWzjLRlTj.yjfxp5Bl7.dqaMmOka";
      };
      "zarel@nix.pizza" = {
        hashedPassword = "$2b$05$QkTJbKhMdJlaZq3QvNNg5O3kXuWzjLRlTj.yjfxp5Bl7.dqaMmOka";
      };
      "albertodvp@nix.pizza" = {
        hashedPassword = "$2b$05$QkTJbKhMdJlaZq3QvNNg5O3kXuWzjLRlTj.yjfxp5Bl7.dqaMmOka";
      };
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
      };

    forwards = {
      "milano@nix.pizza" = [
        "andrea.ciceri@autistici.org"
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
