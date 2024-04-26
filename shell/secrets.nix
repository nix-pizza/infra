toplevel@{ inputs, lib, ... }:
let
  inherit (lib) attrValues concatMapStringsSep genAttrs;
in
{
  imports = [ inputs.agenix-shell.flakeModules.default ];
  agenix-shell.secrets = lib.mapAttrs'
    (filename: _: lib.nameValuePair
      (lib.removeSuffix ".age" filename)
      { file = ../secrets + "/${filename}"; })
    (import ../secrets/secrets.nix);

  perSystem =
    { lib
    , config
    , ...
    }: {
      devshells.default = {
        devshell.startup.open-secrets.text = ''
          source ${lib.getExe config.agenix-shell.installationScript}
        '';
      };
    };
}
