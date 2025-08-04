{
  config,
  lib,
  ...
}:
let
  cfg = config.services.lumi.k3s;
in
{
  services.k3s = {
    enable = cfg.enable;

    role = "server";
    tokenFile = config.services.onepassword-secrets.secretPaths.k3sToken;
  };

  networking.firewall.allowedTCPPorts = [ 6443 ];

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
