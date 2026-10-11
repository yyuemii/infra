{
  description = "infra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko-zfs = {
      url = "github:numtide/disko-zfs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };

    navi = {
      url = "github:cafkafk/navi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opnix = {
      url = "github:brizzbuzz/opnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        # all development systems are aarch64 based
        "aarch64-linux"
        "aarch64-darwin"
      ];

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            inputs.opnix.overlays.default
          ];
        };

      hive = inputs.navi.lib.makeHive (import ./hosts/default.nix { inherit inputs; });
    in
    {
      # export the hive for navi to use
      naviHive = hive;

      # fixes an issue with disko not being able properly find it's run script
      nixosConfigurations = hive.nodes;

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.git
              pkgs.opnix

              inputs.navi.packages.${system}.navi
            ];
          };
        }
      );
    };
}
