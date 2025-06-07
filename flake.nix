{
  description = "infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      ...
    }@inputs:
    let
      hosts = import ./hosts { inherit inputs; };
    in
    {
      inherit (hosts) nixosConfigurations;
    };
}
