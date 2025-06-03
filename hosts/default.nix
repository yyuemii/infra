{
  config,
  lib,
  pkgs,
  ...
}:
let
  hosts = [
    ./asteria
  ];
in
{
  imports = hosts;
}
