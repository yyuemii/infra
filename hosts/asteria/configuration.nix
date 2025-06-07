{
  ...
}:
{
  networking.hostName = "asteria"; # asteria.lu.mi
  networking.wireless.enable = false;

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = false; # wifi

  time.timeZone = "America/New_York";

  system.stateVersion = "25.05";
}
