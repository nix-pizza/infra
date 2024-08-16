{ pkgs, lib, ... }:
let
  markdown = ./nix-milano.md;
  css = ./nix-milano.css;
  nix-milano = pkgs.runCommandNoCC "nix-milano" { } ''
    mkdir $out
    cd $out
    cp ${css} nix-milano.css
    cp -R ${./assets} assets
    ${lib.getExe pkgs.pandoc} --from markdown --css nix-milano.css -s ${markdown} -o index.html --metadata title="Nix Milano"
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
