{ pkgs, lib, ... }:
let
  nix-milano = pkgs.runCommandNoCC "nix-milano" { } ''
    mkdir $out
    cd $out
    cp ${./logo.svg} logo.svg
    ${lib.getExe pkgs.pandoc} \
      -s \
      --embed-resources \
      --from markdown \
      ${./nix-milano.md} \
      --css ${./nix-milano.css}  \
      -o index.html \
      --metadata title="Nix Milano"
  '';
in
{
  services.nginx = {
    virtualHosts."milano.nix.pizza" = {
      enableACME = true;
      forceSSL = true;
      locations."/".root = nix-milano;
    };
  };
}
