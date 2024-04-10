toplevel@{ inputs, lib, ... }:
let
  inherit (lib) attrValues concatMapStringsSep genAttrs;
in
{
  imports = [ inputs.agenix-shell.flakeModules.default ];
  agenix-shell.secrets = genAttrs [
    "AWS_ACCESS_KEY_ID"
    "AWS_SECRET_ACCESS_KEY"
    "AWS_ENDPOINT_URL_S3"

    "TF_VAR_cloudflare_account_id"
    "TF_VAR_cloudflare_api_token"
    "TF_VAR_cloudflare_dns_token"

    "TF_VAR_hcloud_token"
  ]
    (v: { file = ../secrets/${v}.age; });

  perSystem =
    { lib
    , config
    , ...
    }: {
      devshells.default = {
        commands = [
          {
            help = "Seal for infra.sshKeys recipients. Usage: 'seal file' to get 'file.age'";
            name = "seal";
            command =
              let
                exe = "${lib.getExe config.agenix-shell.agePackage}";
                recipients = concatMapStringsSep " " (k: "-r '${k}'") (attrValues toplevel.config.infra.sshKeys);
                target = "-o $1.age $1";
              in
              "${exe} ${recipients} ${target}";
          }
        ];
        devshell.startup.open-secrets.text = ''
          source ${lib.getExe config.agenix-shell.installationScript}
        '';
      };
    };
}
