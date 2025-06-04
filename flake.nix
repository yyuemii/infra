{
  description = "infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      hosts = import ./hosts { inherit nixpkgs; };
    in
    {
      inherit (hosts) nixosConfigurations;
    };
}
