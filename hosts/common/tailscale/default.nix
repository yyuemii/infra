{
  lib,
  ...
}:
{
  imports = [
    ./tailscale.nix
  ];

  options.services.lumi.tailscale = {
    enable = lib.mkEnableOption "Enable Tailscale module";

    routes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of node routes that will be advertised to Tailscale";

      default = [ ];
    };

    exitNode = lib.mkOption {
      type = lib.types.bool;
      description = "Advertises node as an exit node";

      default = false;
    };
  };
}
