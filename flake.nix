{
  description = "infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    opnix.url = "github:brizzbuzz/opnix";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # all development devices im using are aarch64 based
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
      ];

      flake =
        let
          hosts = import ./hosts { inherit inputs; };
        in
        {
          inherit (hosts) nixosConfigurations;
        };

      perSystem =
        {
          config,
          system,
          pkgs,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;

            overlays = [
              inputs.opnix.overlays.default
            ];
          };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixos-anywhere
              nixos-rebuild

              opnix
            ];
          };
        };
    };
}
