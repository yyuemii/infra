{ config, lib, ... }:
{
  imports = [
    ../common/k3s
    ../common/tailscale
  ];

  services.lumi.k3s = {
    enable = true;

    fluxcd = {
      enable = true;

      repository = "https://github.com/yyuemii/infra";
      path = "services";
    };
  };

  services.lumi.tailscale = {
    enable = true;

    routes = [
      # advertise dns server and server ip addr for routing of lu.mi
      "${lib.elemAt config.networking.nameservers 0}/32"
      "${(lib.elemAt config.networking.interfaces.enp0s31f6.ipv4.addresses 0).address}/32"
    ];
  };
}
