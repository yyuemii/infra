{
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;

  hosts = {
    asteria = import ./asteria { inherit inputs lib; };
  };

  # standard pre-requisites for any infra host
  systemModules = [
    inputs.disko.nixosModules.disko
    (import ./common)
  ];

in
{
  nixosConfigurations = (
    builtins.mapAttrs (
      name: host:
      lib.nixosSystem {
        inherit (host) system;

        modules = systemModules ++ host.modules;
      }
    ) hosts
  );
}
