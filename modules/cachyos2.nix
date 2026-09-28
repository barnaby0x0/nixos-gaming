{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.cachyos.cpu = lib.mkOption {
    type = lib.types.enum [
      "amd"
      "intel"
    ];

    default = "amd";

    description = "CPU vendor used for CachyOS-specific configuration.";
  };

  config = {
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

    boot.kernelParams = lib.optionals (config.cachyos.cpu == "amd") [
      "amd_pstate=active"
    ];

    boot.kernelModules =
      if config.cachyos.cpu == "amd" then
        [
          "kvm-amd"
        ]
      else
        [
          "kvm-intel"
        ];

    hardware.cpu.amd.updateMicrocode = lib.mkIf (config.cachyos.cpu == "amd") true;

    hardware.cpu.intel.updateMicrocode = lib.mkIf (config.cachyos.cpu == "intel") true;
  };
}
