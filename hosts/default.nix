{
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;

  hosts = [
    ./nymane
  ];

  defaultImports = [
    inputs.disko.nixosModules.disko
    inputs.disko-zfs.nixosModules.default
    inputs.opnix.nixosModules.default

    ./configuration.nix
    ./services.nix
    ./users.nix
  ];
in
{
  meta = {
    nixpkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
    };

    facts = {
      dirName = ".navi/facts";
    };

    provisioners.bare-metal = {
      type = "bare-metal";

      nixosAnywhere = {
        enable = true;
        extraArgs = [
          "--build-on-remote"
        ];
      };
    };
  };

  defaults = {
    _module.args.inputs = inputs;

    deployment = {
      provisioner = "bare-metal";

      targetUser = "brianna";
      buildOnTarget = true;
    };
  };
}
// lib.listToAttrs (
  map (
    file:
    let
      host = import file { inherit inputs lib; };
    in
    lib.nameValuePair host.name {
      imports = defaultImports ++ host.imports;
    }
  ) hosts
)
