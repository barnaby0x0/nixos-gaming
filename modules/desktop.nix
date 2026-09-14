{
  pkgs,
  ...
}:

{
  services.displayManager.sddm.enable = true;

  services.desktopManager.plasma6.enable = true;

  services.xserver.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
  };

  security.rtkit.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.dolphin
    kdePackages.konsole
  ];
}
