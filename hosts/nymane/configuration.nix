{ ... }:
{
  networking = {
    hostName = "nymane"; # nymane.lu.mi
    hostId = "91c5465b";

    interfaces.eno1.useDHCP = true;

    firewall = {
      enable = true;

      interfaces = {
        eno1 = {
          allowedTCPPorts = [
            22
            80
            443
          ];
          allowedUDPPorts = [ 443 ];
        };
      };
    };
  };

  system.stateVersion = "26.05";
}
