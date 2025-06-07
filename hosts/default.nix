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
  defaultModules = [
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

        modules = defaultModules ++ host.modules;
      }
    ) hosts
  );
}
