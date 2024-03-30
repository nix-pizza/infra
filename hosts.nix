{ inputs, ... }: {
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

        # TODO centralize
        users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzCmDCtlGscpesHuoiruVWD2IjYEFtaIl9Y2JZGiOAyf3V17KPx0MikcknfmxSHi399SxppiaXQHxo/1wjGxXkXNTTv6h1fBuqwhJE6C8+ZSV+gal81vEnXX+/9w2FQqtVgnG2/mO7oJ0e3FY+6kFpOsGEhYexoGt/UxIpAZoqIN+CWNhJIASUkneaZWtgwiL8Afb59kJQ2E7WbBu+PjYZ/s5lhPobhlkz6s8rkhItvYdiSHT0DPDKvp1oEbxsxd4E4cjJFbahyS8b089NJd9gF5gs0b74H/2lUUymnl63cV37Mp4iXB4rtE69MbjqsGEBKTPumLualmc8pOGBHqWIdhAqGdZQeBajcb6VK0E3hcU0wBB+GJgm7KUzlAHGdC3azY0KlHMrLaZN0pBrgCVR6zBNWtZz2B2qMBZ8Cw+K4vut8GuspdXZscID10U578GxQvJAB9CdxNUtrzSmKX2UtZPB1udWjjIAlejzba4MG73uXgQEdv0NcuHNwaLuCWxTUT5QQF18IwlJ23Mg8aPK8ojUW5A+kGHAu9wtgZVcX1nS5cmYKSgLzcP1LA1l9fTJ1vqBSuy38GTdUzfzz7AbnkRfGPj2ALDgyx17Rc5ommjc1k0gFoeIqiLaxEs5FzDcRyo7YvZXPsGeIqNCYwQWw3+U+yUEJby8bxGb2d/6YQ==" ];

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
