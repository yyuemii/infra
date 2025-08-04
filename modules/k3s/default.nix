{
  lib,
  ...
}:
{
  imports = [
    ./server.nix
  ];

  options.services.lumi.k3s = {
    enable = lib.mkEnableOption "k3s";
  };
}
