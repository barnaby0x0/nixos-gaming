{ pkgs, ... }:

{
  imports = [
    ./disko.nix
  ];

  system.stateVersion = "25.11";

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
