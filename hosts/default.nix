{ config, inputs, ... }: {
  flake.nixosConfigurations.nix-pizza = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      ./nix-pizza
      inputs.disko.nixosModules.disko
      inputs.srvos.nixosModules.hardware-hetzner-online-arm
      inputs.srvos.nixosModules.server
      inputs.impermanence.nixosModules.impermanence
      inputs.agenix.nixosModules.age
      inputs.simple-nixos-mailserver.nixosModules.mailserver
      {
        users.users.root.openssh.authorizedKeys.keys = with config.infra.sshKeys; [
          aciceri.key
          zarelit.key
        ];
      }
    ];
  };
}
