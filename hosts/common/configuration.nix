{ ... }:
let
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIET/PP73iMiUF4s2aSz0y8M0hSbjkGhG4fRH10y5iOVl brianna"
  ];
in
{
  users.users.brianna = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = authorizedKeys;
  };

  users.users.root = {
    initialHashedPassword = "!";
  };
}
