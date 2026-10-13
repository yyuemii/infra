{ ... }:
{
  imports = [
    ../../modules/k3s
  ];

  services.lumi.k3s = {
    enable = true;

    zfs = true;

    fluxcd = {
      enable = true;

      repository = "https://github.com/yyuemii/infra.git";
      path = "cluster?ref=navi"; # TODO: remove when navi rewrite is merged into main
    };
  };

  services.onepassword-secrets.secrets = {
    k3sToken = {
      reference = "op://lumi/infra-k3s-token/token";
      mode = "0600";
      services = [ "k3s" ];
    };
  };
}
