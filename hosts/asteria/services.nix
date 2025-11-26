{ ... }:
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
  };
}
