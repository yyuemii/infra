{
  inputs,
  pkgs,
  ...
}:
{
  networking.hostName = "asteria"; # asteria.lu.mi
  networking.wireless.enable = false;

  time.timeZone = "America/New_York";

  environment.systemPackages = [
    # since i develop on a mac and build directly on asteria, i need to install the agent there to use secrets
    # todo: setup some sort of build agent with this installed instead. this will do for now
    inputs.opnix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  system.stateVersion = "25.05";
}
