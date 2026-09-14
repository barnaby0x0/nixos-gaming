{
  pkgs,
  ...
}:

{
  programs.steam = {
    enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
    steam-run
    vulkan-tools
    mesa-demos
    goverlay
    vkbasalt
    wine
    winetricks
    lutris
    heroic
  ];

  environment.variables = {
    MANGOHUD = "1";
  };
}
