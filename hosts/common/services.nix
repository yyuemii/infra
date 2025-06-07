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
}
