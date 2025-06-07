{
  inputs,
  ...
}:
{
  name = "asteria";
  system = "x86_64-linux";

  modules = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-intel-gen5

    ./configuration.nix
    ./hardware.nix
  ];
}
