{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./postgres.nix
    ./backup.nix
    ./fail2ban.nix
    ./nginx.nix
    ./mail.nix
    ./hedgedoc.nix
    ./wastebin.nix
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
  networking = {
    hostName = "nix-pizza";
    domain = "nix.pizza";
  };

  systemd.network.networks."10-uplink".networkConfig.Address = "2a01:4f8:c013:2189::1/64";

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

  # Agenix decrypts before impermanence creates mounts so we have to get keys from /persist
  age.identityPaths = [
    "/persist/etc/ssh/ssh_host_ed25519_key"
    "/persist/etc/ssh/ssh_host_rsa_key"
  ];

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
}
