{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lumi.k3s;
in
{
  environment.systemPackages = with pkgs; [
    kubectl
    kubernetes-helm
    kustomize
  ];

  services.k3s = {
    enable = cfg.enable;
    
    tokenFile = config.services.onepassword-secrets.secretPaths.k3sToken;

    role = "server";
    extraFlags = [
      "--tls-san=${config.networking.hostName}"
      "--tls-san=${config.networking.hostName}.${config.networking.domain}"
      "--cluster-domain=${config.networking.domain}"
      "--cluster-cidr=${cfg.clusterSubnet}"
      "--service-cidr=${cfg.servicesSubnet}"
    ];
  };

  networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [
    6443
  ];

  services.onepassword-secrets.secrets = lib.mkIf cfg.enable {
    k3sToken = {
      reference = "op://lumi/pw-k3s-token/token";
      mode = "0600";
      services = [ "k3s" ];
      # owner = "k3s";
      # group = "k3s";
    };
  };
}
