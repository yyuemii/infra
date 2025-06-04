{
  nixpkgs,
  ...
}:
let
  inherit (nixpkgs) lib;

  hosts = {
    asteria = import ./asteria { inherit lib; };
  };

  # standard pre-requisites for any infra host
  systemModules = [ ];
in
{
  nixosConfigurations = (
    builtins.mapAttrs (
      name: host:
      lib.nixosSystem {
        inherit (host) system;

        modules = systemModules ++ host.modules ++ import ./common { inherit lib; };
      }
    ) hosts
  );
}
