{ inputs, config, ... }: {
  # TODO separate flake-parts module from NixOS modules
  flake.nixosConfigurations.nix-pizza = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";

    modules = [
      ({ modulesPath, ... }: {
        imports = [
          inputs.disko.nixosModules.disko
          inputs.srvos.nixosModules.hardware-hetzner-online-arm
          inputs.srvos.nixosModules.server
          (modulesPath + "/profiles/qemu-guest.nix")
        ];

        boot.kernelParams = [ "console=tty" ];
        boot.initrd.kernelModules = [ "virtio_gpu" ];

        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.systemd-boot = {
          enable = true;
          configurationLimit = 20;
        };

        system.stateVersion = "23.05";
        networking.hostName = "nix-pizza";

        systemd.network.networks."10-uplink".networkConfig.Address = "2a01:4f9:c010:52fd::1/128";

        users.users.root.openssh.authorizedKeys.keys = with config.infra.sshKeys; [
          aciceri.key
          zarelit.key
        ];

        disko.devices = {
          disk = {
            vdb = {
              device = "/dev/sda";
              type = "disk";
              content = {
                type = "gpt";
                partitions = {
                  ESP = {
                    type = "EF00";
                    size = "500M";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                    };
                  };
                  root = {
                    size = "100%";
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/";
                    };
                  };
                };
              };
            };
          };
        };
      })
    ];
  };
}
