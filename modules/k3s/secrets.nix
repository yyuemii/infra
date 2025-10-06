{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lumi.k3s;

  namespace = "op-connect";
  secret = "op-connect";
in
{
  # only enable if core k3s is enabled
  config = lib.mkIf cfg.enable {
    services.onepassword-secrets.secrets = {
      opConnectToken = {
        reference = "op://lumi/infra-op-connect/token";
        mode = "0600";
        services = [ "k3s" ];
      };

      opConnectCredentials = {
        reference = "op://lumi/infra-op-connect/credentials";
        mode = "0600";
        services = [ "k3s" ];
      };
    };

    systemd.services.secrets-bootstrap = {
      description = "Bootstraps necessary secrets for k3s to function properly";
      
      after = [ "k3s.service" ];
      wants = [ "k3s.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };

      path = with pkgs; [ 
        kubectl 
        kubernetes-helm
      ];

      serviceConfig = {
        Type = "oneshot";

        Restart = "on-failure";
        RestartSec = "30s";

        ExecStart = pkgs.writeShellScript "secrets-bootstrap.sh" ''
          set -e

          # init secrets namespace
          kubectl create namespace ${namespace} --dry-run=client -o yaml | kubectl apply -f -

          # setup secrets for 1password-credentials.json and access token
          if ! kubectl get secret ${secret} --namespace=${namespace} &> /dev/null; then
            kubectl create secret generic ${secret} \
              --namespace=${namespace} \
              --from-file=credentials=${config.services.onepassword-secrets.secretPaths.opConnectCredentials} \
              --from-file=token=${config.services.onepassword-secrets.secretPaths.opConnectToken}
          fi
        '';
      };
    };
  };

  
}
