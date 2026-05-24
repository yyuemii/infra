{
  inputs,
  ...
}:
{
  name = "asteria";
  system = "x86_64-linux";

  modules = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen5
    inputs.nix-minecraft.nixosModules.minecraft-servers
    {
      nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
    }

    ./configuration.nix
    ./hardware.nix
    ./services.nix
  ];
}
