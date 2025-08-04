{ ... }:
{
  imports = [
    ../../modules/k3s
  ];

  services.lumi.k3s.enable = true;
}
