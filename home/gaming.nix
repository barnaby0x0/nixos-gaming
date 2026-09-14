{
  pkgs,
  ...
}:

{
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    jq
    yq
    ripgrep
    fd
    fzf

    btop
    htop

    mangohud
    protonup-qt
  ];

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-gaming#gaming";
      update = "nix flake update ~/nixos-gaming";
    };
  };

  programs.git = {
    enable = true;

    userName = "user";
    userEmail = "change-me@example.com";
  };
}
