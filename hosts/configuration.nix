{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true; # nvidia drivers (lol)

  environment.systemPackages = [
    # since i develop on a mac and build directly on remote, i need to install the opnix agent on targets to use secrets
    # todo: setup some sort of build agent with this installed instead. this will do for now
    inputs.opnix.packages.${pkgs.stdenv.hostPlatform.system}.default

    pkgs.vim
    pkgs.curl
    pkgs.gitMinimal
  ];

  networking = {
    domain = lib.mkDefault "lu.mi";

    useDHCP = lib.mkDefault false;
    useNetworkd = lib.mkDefault true; # handles fqdn properly

    enableIPv6 = lib.mkDefault false;
  };

  time.timeZone = lib.mkDefault "America/New_York";
}
