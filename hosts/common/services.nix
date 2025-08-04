{ ... }:
{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
    };
    # permitRootLogin = lib.mkDefault "no";
  };

  services.fwupd.enable = true;

  # always ensure the opnix agent is running for dependent services
  services.onepassword-secrets = {
    enable = true;
    tokenFile = "/etc/opnix-token";

    secrets = { };
  };
}
