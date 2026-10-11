{ config, lib, ... }:
{
  services.openssh = {
    enable = lib.mkDefault true;

    settings = {
      PasswordAuthentication = lib.mkDefault false;
    };
  };

  services.resolved.enable = lib.mkDefault true;

  services.fwupd.enable = lib.mkDefault true;

  services.onepassword-secrets = {
    # opnix requires at least one secret to run, so if a host doesn't require any, don't enable the service
    enable = lib.mkDefault (
      builtins.length (builtins.attrNames config.services.onepassword-secrets.secrets) > 0
    );
    tokenFile = lib.mkDefault "/etc/opnix-token";
  };
}
