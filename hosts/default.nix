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
    inputs.opnix.nixosModules.default
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
        specialArgs = {
          inherit inputs;
        };
      }
    ) hosts
  );
}
