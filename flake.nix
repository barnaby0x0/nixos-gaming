{
  description = "NixOS Gaming - CachyOS optimized gaming system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };

    #dotfiles.url = "path:../dotfiles";

    dotfiles = {
      url = "github:barnaby0x0/nixdot";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      nix-cachyos-kernel,
      dotfiles,
      ...
    }:

    let
      system = "x86_64-linux";
    in
    {

      nixosConfigurations.gaming = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [

          # === Overlay pour corriger lazarus ===
{
  nixpkgs.overlays = [
    (final: prev: {
      lazarus-qt6 = prev.lazarus-qt6.overrideAttrs (old: {
        postInstall =
          builtins.replaceStrings
            [
              ''  --prefix NIX_LDFLAGS ' ' "$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')" \
''
              ''  --prefix NIX_LDFLAGS_x86_64_unknown_linux_gnu ' ' "$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')" \
''
            ]
            [
              ""
              ""
            ]
            old.postInstall;
      });
    })
  ];
}

          # Nixpkgs configuration + CachyOS overlay
          {
            nixpkgs.config.allowUnfree = true;

            nixpkgs.overlays = [
              nix-cachyos-kernel.overlays.pinned
            ];
          }

          # Disko
          disko.nixosModules.disko

          # Host configuration
          ./hosts/gaming

          # System modules
          ./modules/cachyos2.nix
          ./modules/desktop.nix
          ./modules/gaming.nix
          ./modules/performance.nix

          # Home Manager
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.user = {
              imports = [
                dotfiles.homeManagerModules.user
              ];
            };
          }
        ];
      };
    };
}
