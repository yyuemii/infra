{ lib, ... }:
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
    enable = lib.mkDefault true;
    tokenFile = lib.mkDefault "/etc/opnix-token";
  };
}
