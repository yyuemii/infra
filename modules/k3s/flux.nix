{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lumi.k3s.fluxcd;

  manifest = "${lib.replaceStrings [ "https://" ] [ "" ] cfg.repository}/${cfg.path}";
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fluxcd
      gitMinimal
    ];

    systemd.services.flux-bootstrap = {
      description = "Bootstraps a flux instance onto the k3s cluster using flux operator";

      after = [ "k3s.service" ];
      wants = [ "k3s.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };

      path = with pkgs; [
        gitMinimal
        kubectl
        kubernetes-helm
      ];

      serviceConfig = {
        Type = "oneshot";

        Restart = "on-failure";
        RestartSec = "30s";

        ExecStart = pkgs.writeShellScript "flux-bootstrap.sh" ''
          set -e

          # install flux operator helm chart to install the neccessary bootstrap components
          helm install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
            --namespace flux-system \
            --create-namespace

          # bootstrap flux instance from the cluster manifests
          kubectl apply -k ${manifest}
        '';
      };
    };
  };
}
