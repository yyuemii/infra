{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.zfs.forceImportRoot = false;
  boot.supportedFilesystems = [ "zfs" ];

  swapDevices = [ ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # disko zfs configuration
  #
  # os: main disk for the main nixos install, cache, logs, etc.
  # data-*: data disks for the kubernetes cluster (4 disks, 2x2 mirror)

  disko = {
    zfs.enable = true;

    devices =
      let
        dataDisk = id: {
          type = "disk";
          device = "/dev/disk/by-id/${id}";
          content = {
            type = "gpt";
            partitions.zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };

        dataDiskIds = [
          "ata-TOSHIBA_KSG60ZMV512G_M.2_2280_512GB_X8HF61PXF5XP"
          "ata-TOSHIBA_KSG60ZMV512G_M.2_2280_512GB_X8HF62BMF5XP"
          "ata-TOSHIBA_KSG60ZMV512G_M.2_2280_512GB_X8HF61L8F5XP"
          "ata-TOSHIBA_KSG60ZMV512G_M.2_2280_512GB_X8HF62BLF5XP"
        ];
      in
      {
        disk =
          {
            os = {
              type = "disk";
              device = "/dev/disk/by-id/ata-SK_hynix_SC401_SATA_512GB_MI8BN03051160BL0H";
              content = {
                type = "gpt";
                partitions = {
                  ESP = {
                    size = "1G";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = [ "umask=0077" ];
                    };
                  };
                  zfs = {
                    size = "100%";
                    content = {
                      type = "zfs";
                      pool = "zroot";
                    };
                  };
                };
              };
            };
          }
          // builtins.listToAttrs (
            builtins.genList (i: {
              name = "data-${toString i}";
              value = dataDisk (builtins.elemAt dataDiskIds i);
            }) (builtins.length dataDiskIds)
          );

        zpool = {
          zroot = {
            type = "zpool";
            mode = "";
            options.ashift = "12";
            rootFsOptions = {
              compression = "zstd";
              atime = "off";
              xattr = "sa";
              acltype = "posixacl";
              mountpoint = "none";
            };
            datasets = {
              root = {
                type = "zfs_fs";
                mountpoint = "/";
                options.mountpoint = "legacy";
              };
              nix = {
                type = "zfs_fs";
                mountpoint = "/nix";
              };
              var = {
                type = "zfs_fs";
                mountpoint = "/var";
              };
              "var/log" = {
                type = "zfs_fs";
                mountpoint = "/var/log";
              };
            };
          };

          tank = {
            type = "zpool";
            options.ashift = "12";
            mode = {
              topology = {
                type = "topology";
                vdev = [
                  {
                    mode = "mirror";
                    members = [
                      "data-0"
                      "data-1"
                    ];
                  }
                  {
                    mode = "mirror";
                    members = [
                      "data-2"
                      "data-3"
                    ];
                  }
                ];
              };
            };
            rootFsOptions = {
              compression = "lz4";
              atime = "off";
              xattr = "sa";
              acltype = "posixacl";
              mountpoint = "none";
            };
            datasets = builtins.listToAttrs (
              map
                (name: {
                  inherit name;
                  value = {
                    type = "zfs_fs";
                    mountpoint = "/srv/${builtins.replaceStrings [ "/" ] [ "/" ] name}";
                  };
                })
                [
                  "kubernetes"
                  "kubernetes/volumes"
                  "kubernetes/databases"
                  "kubernetes/backups"
                ]
            );
          };
        };
      };
  };
}
