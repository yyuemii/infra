{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lumi.tailscale;
in
{

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tailscale
    ];

    networking = {
      firewall = {
        allowedUDPPorts = [
          config.services.tailscale.port
        ];

        trustedInterfaces = [ config.services.tailscale.interfaceName ];

        checkReversePath = "loose";
      };

      networkmanager.unmanaged = [ "tailscale0" ];
    };

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

    services.tailscale = {
      enable = true;
    };
  };

}
