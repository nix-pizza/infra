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
          inputs.impermanence.nixosModules.impermanence
          (modulesPath + "/profiles/qemu-guest.nix")
        ];

        boot.kernelParams = [ "console=tty" ];
        boot.initrd.kernelModules = [ "virtio_gpu" ];
        boot.initrd.systemd.enable = true;

        boot.loader.efi.canTouchEfiVariables = true;
        boot.loader.systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };

        system.stateVersion = "23.05";
        networking.hostName = "nix-pizza";

        systemd.network.networks."10-uplink".networkConfig.Address = "2a01:4f9:c010:52fd::1/128";

        users.users.root.openssh.authorizedKeys.keys = with config.infra.sshKeys; [
          aciceri.key
          zarelit.key
        ];

        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/etc/NetworkManager/system-connections"
            "/var/db/dhcpcd/"
            "/var/lib/NetworkManager/"
            "/var/lib/nixos"
            "/var/lib/systemd"
            "/var/lib/systemd/coredump"
            "/var/log"
          ];
          files = [
            "/etc/machine-id"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/ssh/ssh_host_rsa_key"
            "/etc/ssh/ssh_host_rsa_key.pub"
          ];
        };

        fileSystems."/persist".neededForBoot = true;
        boot.tmp.cleanOnBoot = true;

        disko.devices = {
          nodev."/" = {
            fsType = "tmpfs";
            mountOptions = [ "size=1024M" "defaults" "mode=755" ];
          };

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
                  nixroot = {
                    start = "512M";
                    end = "-15G";
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/nix";
                    };
                  };
                  persist = {
                    start = "-15G";
                    end = "-5G";
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/persist";
                    };
                  };
                  tmp = {
                    start = "-5G";
                    end = "-4G";
                    content = {
                      type = "filesystem";
                      format = "ext4";
                      mountpoint = "/tmp";
                    };
                  };
                  swap = {
                    size = "100%";
                    content = {
                      type = "swap";
                      randomEncryption = true;
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
