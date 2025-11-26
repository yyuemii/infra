{
  lib,
  ...
}:
{
  imports = [
    ./node.nix
  ];

  options.services.lumi.tailscale = {
    enable = lib.mkEnableOption "Enable Tailscale module";
  };
}
