{
  pkgs,
  ...
}:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "fr";

  users.users.user = {
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "audio"
    ];

    initialPassword = "changeme";
  };

  security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    pciutils
    usbutils
    htop
    btop
    fastfetch
  ];
}
