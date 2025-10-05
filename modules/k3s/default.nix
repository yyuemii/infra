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

    fluxcd = {
      enable = lib.mkEnableOption "Enable fluxcd module";

      repository = lib.mkOption {
        type = lib.types.str;
        description = "URL of the repository";
      };
    };
  };
}
