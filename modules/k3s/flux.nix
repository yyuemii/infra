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

      serviceConfig = {
        Type = "oneshot";

        Restart = "on-failure";
        RestartSec = 5;

        ExecStart = pkgs.writeShellScript "flux-bootstrap" ''
          set -e

          if ! ${pkgs.kubectl}/bin/kubectl get ns flux-system >/dev/null 2>&1; then
            ${pkgs.fluxcd}/bin/flux bootstrap github \
              --owner=${cfg.repository.owner} \
              --repository=${cfg.repository.name} \
              --branch=main \
              --path=${cfg.repository.path} \
              --private=false \
              --personal=true \
          else
            echo "Flux is already bootstrapped; exiting"
          fi
        '';
      };
    };
  };
}
