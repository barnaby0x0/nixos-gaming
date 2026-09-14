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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  service.blueman.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";

  i18n = {
    defaultLocale = "fr_CH.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "fr_CH.UTF-8";
      LC_IDENTIFICATION = "fr_CH.UTF-8";
      LC_MEASUREMENT = "fr_CH.UTF-8";
      LC_MONETARY = "fr_CH.UTF-8";
      LC_NAME = "fr_CH.UTF-8";
      LC_NUMERIC = "fr_CH.UTF-8";
      LC_PAPER = "fr_CH.UTF-8";
      LC_TELEPHONE = "fr_CH.UTF-8";
      LC_TIME = "fr_CH.UTF-8";
    };
  };

  console.keyMap = "fr";
  services.xserver = {
    xkb.layout = "fr";
  };

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
    brave
  ];

  nix.settings = {
    trusted-users = [
      "root"
      "user"
    ];

    substituters = [
      "https://cache.nixos.org/"
      "https://attic.xuyh0120.win/lantian"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };
}