{ config, lib, pkgs, ... }:

{
  options.hardware.cpu.vendor = lib.mkOption {
    type = lib.types.enum [
      "amd"
      "intel"
    ];

    description = "CPU vendor used for CPU-specific configuration.";
  };

  config = {
    boot.kernelPackages =
      pkgs.cachyosKernels.linuxPackages-cachyos-latest;

    boot.kernelParams =
      lib.optionals (config.hardware.cpu.vendor == "amd") [
        "amd_pstate=active"
      ];

    boot.kernelModules =
      if config.hardware.cpu.vendor == "amd"
      then [ "kvm-amd" ]
      else [ "kvm-intel" ];

    hardware.cpu.amd.updateMicrocode =
      lib.mkIf (config.hardware.cpu.vendor == "amd") true;

    hardware.cpu.intel.updateMicrocode =
      lib.mkIf (config.hardware.cpu.vendor == "intel") true;
  };
}