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
  
    settings = {
      user = {
        name = "user";
        email = "change-me@example.com";
      };
    };
  };

}
