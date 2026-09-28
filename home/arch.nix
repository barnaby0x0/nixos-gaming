{ pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "25.11";

  #  home.packages = with pkgs; [
  #    ripgrep
  #    fd
  #    fzf
  #    jq
  #    yq
  #    git
  #  ];

  #  programs.zsh.enable = true;

  #  programs.git.enable = true;
}
