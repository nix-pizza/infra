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

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
