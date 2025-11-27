{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.lumi.k3s.oidc;
in
{
  config = lib.mkIf cfg.enable {
    services.onepassword-secrets.secrets = {
      k3sOIDCClient = {
        reference = "op://lumi/infra-k3s-oidc/username";
        mode = "0600";
      };
    };

    # use an prestart script to drop oidc config into the k3s config dir
    # we use opnix to place secrets to disk, so we can't (and really shouldn't) place the config in the extraFlags
    systemd.services.k3s.preStart = ''
      mkdir -p /etc/rancher/k3s/config.yaml.d

      cat > /etc/rancher/k3s/config.yaml.d/oidc.yaml <<EOF
      kube-apiserver-arg:
        - "oidc-issuer-url=${cfg.issuer}"
        - "oidc-client-id=$(cat ${config.services.onepassword-secrets.secretPaths.k3sOIDCClient})"
        - "oidc-username-claim=email"
        - "oidc-groups-claim=groups"
        - "oidc-groups-prefix=oidc:"
      EOF
    '';

    systemd.services.k3s-oidc-bootstrap = {
      description = "Bootstraps OIDC group role definitions onto k3s";

      after = [ "k3s.service" ];
      wants = [ "k3s.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      };

      path = with pkgs; [
        kubectl
      ];

      serviceConfig = {
        Type = "oneshot";

        Restart = "on-failure";
        RestartSec = "30s";

        ExecStart = pkgs.writeShellScript "k3s-oidc-bootstrap.sh" ''
          set -e

          # apply oidc group role definitions
          ${lib.concatMapStringsSep "\n" (group: ''
            kubectl apply -f - <<EOF
            apiVersion: rbac.authorization.k8s.io/v1
            kind: ClusterRoleBinding
            metadata:
              name: oidc-${group}-${cfg.roles.${group}}
            roleRef:
              apiGroup: rbac.authorization.k8s.io
              kind: ClusterRole
              name: ${cfg.roles.${group}}
            subjects:
            - kind: Group
              name: oidc:${group}
            EOF
          '') (lib.attrNames cfg.roles)}
        '';
      };
    };
  };
}
