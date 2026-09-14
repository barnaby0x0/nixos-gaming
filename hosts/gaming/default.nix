{ pkgs, ... }:

{
  system.stateVersion = "25.11";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];
}
