{
  lib,
  ...
}:
{
  imports = [
    ./flux.nix
    ./server.nix
  ];

  options.services.lumi.k3s = {
    enable = lib.mkEnableOption "Enable k3s module";

    zfs = lib.mkEnableOption "Enable zfs snapshotter";

    fluxcd = {
      enable = lib.mkEnableOption "Enable fluxcd module";

      repository = lib.mkOption {
        type = lib.types.str;
        description = "URL of the synced repository";
      };

      path = lib.mkOption {
        type = lib.types.str;
        description = "Path to where the cluster manifests are located";
      };
    };
  };
}
