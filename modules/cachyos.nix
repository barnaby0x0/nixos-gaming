{
  pkgs,
  ...
}:

{
  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  boot.kernelParams = [
    "amd_pstate=active"
  ];

  boot.kernelModules = [
    "kvm-amd"
  ];
}
