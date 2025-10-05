{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lumi.k3s.fluxcd;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fluxcd
    ];

    systemd.services.flux-bootstrap = {
      description = "Bootstraps FluxCD onto k3s";
      
      after = [ "k3s.service" ];
      wants = [ "k3s.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };

      path = with pkgs; [ 
        kubectl 
        kubernetes-helm 
        fluxcd
      ];

      serviceConfig = {
        Type = "oneshot";

        Restart = "on-failure";
        RestartSec = "30s";

        ExecStart = pkgs.writeShellScript "flux-bootstrap.sh" ''
          set -e

          # init flux system namespace
          kubectl create namespace flux-system --dry-run=client -o yaml | kubectl apply -f -

          # install flux resources into namespace
          flux install --namespace=flux-system

          # setup git repo source for flux to sync with
          kubectl apply -f - <<EOF
          apiVersion: source.toolkit.fluxcd.io/v1
          kind: GitRepository
          metadata:
            name: flux-system
            namespace: flux-system
          spec:
            interval: 1m
            url: ${cfg.repository}
            ref:
              branch: main
          EOF

          # bootstrap flux
          kubectl apply -f - <<EOF
          apiVersion: kustomize.toolkit.fluxcd.io/v1
          kind: Kustomization
          metadata:
            name: flux-bootstrap
            namespace: flux-system
          spec:
            interval: 1m
            path: ./apps/flux
            prune: false
            sourceRef:
              kind: GitRepository
              name: flux-system
          EOF
        '';
      };
    };
  };
}
