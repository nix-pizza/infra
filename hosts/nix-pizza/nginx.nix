{
  security.acme = {
    acceptTerms = true;
    defaults.email = "info@nix.pizza";
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  # Just for testing
  services.nginx.virtualHosts."ananas.nix.pizza" = {
    default = true;
    enableACME = true;
    forceSSL = true;
    locations = {
      "/" = {
        return = ''200 "Pizza con l'ananas"'';
        extraConfig = "add_header Content-Type text/plain;";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
