{
  lib,
  ...
}:
{
  imports = [
    ./secrets.nix
    ./server.nix
    ./flux.nix
  ];

  options.services.lumi.k3s = {
    enable = lib.mkEnableOption "Enable k3s module";

    fluxcd = {
      enable = lib.mkEnableOption "Enable fluxcd module";

      repository = lib.mkOption {
        type = lib.types.str;
        description = "URL of the repository";
      };

      path = lib.mkOption {
        type = lib.types.str;
        description = "Path to where manifests are located";

        default = "";
      };
    };
  };
}
