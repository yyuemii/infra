{
  lib,
  ...
}:
{
  imports = [
    ./server.nix
    ./flux.nix
  ];

  options.services.lumi.k3s = {
    enable = lib.mkEnableOption "Enable k3s module";

    clusterSubnet = lib.mkOption {
      type = lib.types.str;
      description = "Subnet used for the k3s cluster pods";
    };

    servicesSubnet = lib.mkOption {
      type = lib.types.str;
      description = "Subnet used for k3s services";
    };

    fluxcd = {
      enable = lib.mkEnableOption "Enable fluxcd module";

      repository = {
        owner = lib.mkOption {
          type = lib.types.str;
          description = "Owner of the repository";
        };

        name = lib.mkOption {
          type = lib.types.str;
          description = "Name of the repository";
        };

        path = lib.mkOption {
          type = lib.types.str;
          description = "Path to use for syncing";
        };
      };
    };
  };
}
