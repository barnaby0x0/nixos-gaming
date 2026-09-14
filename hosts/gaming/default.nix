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
