{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lumi.tailscale;

  flags = [
    "--advertise-routes=${lib.concatStringsSep "," cfg.routes}"
    "--advertise-exit-node=${lib.boolToString cfg.exitNode}"
  ];
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tailscale
    ];

    services.onepassword-secrets.secrets = {
      tailscaleToken = {
        reference = "op://Lumi/infra-tailscale-token/password";
        mode = "0600";
      };
    };

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

    # setup for subnet routing
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

    services.tailscale = {
      enable = true;

      authKeyFile = config.services.onepassword-secrets.secretPaths.tailscaleToken;

      extraUpFlags = flags;
      extraSetFlags = flags;
    };
  };
}
