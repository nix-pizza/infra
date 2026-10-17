{ inputs, lib, ... }:
let
  inherit ((import ../keys).infra.sshKeys) github;
  # Only secrets readable by the CI key become environment variables; the
  # others are credentials kept for humans.
  secrets = lib.filterAttrs (_: secret: builtins.elem github.key secret.publicKeys) (import ../secrets/secrets.nix);
in
{
  imports = [ inputs.agenix-shell.flakeModules.default ];

  agenix-shell.secrets = lib.mapAttrs'
    (filename: _: lib.nameValuePair
      (lib.removeSuffix ".age" filename)
      { file = ../secrets + "/${filename}"; })
    secrets;

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
