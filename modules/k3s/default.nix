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

    fluxcd = {
      enable = lib.mkEnableOption "Enable fluxcd module";

      repository = lib.mkOption {
        type = lib.types.str;
        description = "URL of the repository";
      };
    };
  };
}
