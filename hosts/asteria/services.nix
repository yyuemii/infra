{ ... }:
{
  imports = [
    ../../modules/k3s
  ];

  services.lumi.k3s = {
    enable = true;

    clusterSubnet = "10.0.20.0/24"; # lu.mi

    fluxcd = {
      enable = true;

      repository = "https://github.com/yyuemii/infra.git";
    };
  };
}
