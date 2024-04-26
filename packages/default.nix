{
  perSystem = {config, pkgs, lib, ...}: {
    packages.inject-secrets = pkgs.writeShellApplication {
      name = "inject-secrets";
      text = ''
	# shellcheck disable=SC1091
	source "${lib.getExe config.agenix-shell.installationScript}"
      '';
    };
  };
}
