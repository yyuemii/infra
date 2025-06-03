{
  config,
  lib,
  pkgs,
  ...
}:
let
  lol = [ ];
in
{
  imports = [
    ./configuration.nix
  ];
}
