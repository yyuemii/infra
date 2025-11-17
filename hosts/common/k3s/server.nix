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
      "--cluster-cidr=172.20.0.0/16"
      "--service-cidr=172.21.0.0/16"
    ];
  };

  # override flannel network to use 172.20.0.0/16 range instead of default 10.42.0.0/24
  environment.etc."rancher/k3s/server/manifests/custom-flannel.yaml".text = lib.mkIf cfg.enable ''
    apiVersion: helm.cattle.io/v1
    kind: HelmChartConfig
    metadata:
      name: rke2-canal
      namespace: kube-system
    spec:
      valuesContent: |
        flannel:
          net-conf:
            Network: "172.20.0.0/16"
  '';

  networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable [
    6443
  ];

  services.onepassword-secrets.secrets = lib.mkIf cfg.enable {
    k3sToken = {
      reference = "op://lumi/infra-k3s-token/token";
      mode = "0600";
      services = [ "k3s" ];
    };
  };
}
