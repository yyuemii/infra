{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common
  ];

  networking.hostName = "asteria";
  networking.searchDomain = "lu.mi";
}
