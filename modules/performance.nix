{
  ...
}:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  boot.kernel.sysctl = {
    # Large virtual memory map for Wine / Proton.
    "vm.max_map_count" = 2147483642;

    # Reduce cache pressure.
    "vm.vfs_cache_pressure" = 50;

    # Prefer keeping memory available for applications.
    "vm.swappiness" = 10;
  };

  powerManagement.cpuFreqGovernor = "performance";

  boot.kernelParams = [
    "preempt=full"
  ];
}
