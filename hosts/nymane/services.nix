{ ... }:
{
  imports = [
    ../../modules/k3s
  ];

  services.lumi.k3s = {
    enable = true;

    fluxcd = {
      enable = true;

      repository = "https://github.com/yyuemii/infra.git";
      path = "cluster?ref=navi"; # TODO: remove when navi rewrite is merged into main
    };
  };
}
