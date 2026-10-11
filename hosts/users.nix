{ lib, ... }:
{
  # always setup root and myself under any hosts
  users.users =
    let
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIET/PP73iMiUF4s2aSz0y8M0hSbjkGhG4fRH10y5iOVl brianna"
      ];
    in
    {
      brianna = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];

        openssh.authorizedKeys.keys = authorizedKeys;
      };

      root = {
        openssh.authorizedKeys.keys = authorizedKeys;
      };
    };

  security.sudo.wheelNeedsPassword = lib.mkDefault false;
}
