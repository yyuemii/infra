{
  lib,
  ...
}:
{
  imports = [
    ./secrets.nix
    ./server.nix
    ./flux.nix
    ./oidc.nix
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

    oidc = {
      enable = lib.mkEnableOption "Enable oidc module";

      issuer = lib.mkOption {
        type = lib.types.str;
        description = "URL of the issuer";
      };

      clientId = lib.mkOption {
        type = lib.types.str;
        description = "Client ID for the oidc provider";
      };

      roles = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Maps an oidc group to a kubernetes role";
      };
    };
  };
}
