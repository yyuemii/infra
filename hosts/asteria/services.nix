{ ... }:
{
  imports = [
    ../../modules/k3s
  ];

  services.lumi.k3s = {
    enable = true;

    clusterSubnet = "10.0.20.0/24"; # lu.mi
    servicesSubnet = "10.0.30.0/24"; # on.lu.mi

    fluxcd = {
      enable = true;

      repository = {
        owner = "yyuemii";
        name = "infra";

        path = "apps";
      };
    };
  };
}
