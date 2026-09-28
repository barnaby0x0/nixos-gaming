{
  pkgs,
  ...
}:

{
  home.stateVersion = "26.05";

  imports = [
    ./programs/bash.nix
    ./programs/git.nix
    ./programs/terminator.nix
    ./programs/vim.nix
    ./programs/zsh2.nix
  ];

  home.packages = with pkgs; [
    git
    jq
    yq
    ripgrep
    fd
    fzf
    btop
    htop
    direnv
    zsh-powerlevel10k
  ];

}
