{
  inputs,
  ...
}:
{
  name = "nymane";

  imports = [
    # nymane's hardware (precision 3630) doesn't have a nixos-hardware module
    "${inputs.nixos-hardware}/common/cpu/intel/coffee-lake"
    "${inputs.nixos-hardware}/common/pc"
    "${inputs.nixos-hardware}/common/pc/ssd"
    "${inputs.nixos-hardware}/common/gpu/nvidia/pascal"

    ./configuration.nix
    ./hardware.nix
    ./services.nix
  ];
}
