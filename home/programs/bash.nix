{ ... }:

{
  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-gaming#gaming";
      update = "nix flake update ~/nixos-gaming";
    };
  };
}
