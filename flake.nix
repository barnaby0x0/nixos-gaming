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

    nix-config = {
      url = "github:barnaby0x0/nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      nix-cachyos-kernel,
      nix-config,
      ...
    }:

    let
      system = "x86_64-linux";

      users = {
        user = {
          enableVirt = true;
          homeManager = true;

          git = {
            name = "Victor";
            email = "victor@mail.net";
          };
        };
      };

      pkgs = nixpkgs.legacyPackages.${system};

    in
    {

      nixosConfigurations.gaming = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit users;
        };

        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              nix-cachyos-kernel.overlays.pinned
              # === Overlay pour corriger lazarus ===
              (final: prev: {
                lazarus-qt6 = prev.lazarus-qt6.overrideAttrs (old: {
                  postInstall =
                    builtins.replaceStrings
                      [
                        ''
                          --prefix NIX_LDFLAGS ' ' "$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')" \
                        ''
                        ''
                          --prefix NIX_LDFLAGS_x86_64_unknown_linux_gnu ' ' "$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')" \
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
          # {
          #   nixpkgs.config.allowUnfree = true;

          #   nixpkgs.overlays = [
          #     nix-cachyos-kernel.overlays.pinned
          #   ];
          # }

          # Disko
          disko.nixosModules.disko

          # Host configuration
          ./hosts/gaming

          # System modules
          ./modules/cachyos2.nix
          ./modules/desktop.nix
          ./modules/gaming.nix
          ./modules/performance.nix
          ./modules/virt.nix

          # Home Manager
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit users;
            };

            home-manager.users = nixpkgs.lib.mapAttrs (name: user: {
              imports = [
                nix-config.homeModules.default
              ];
              home.stateVersion = "26.05";
              my.user.git = user.git;
            }) (nixpkgs.lib.filterAttrs (_: user: user.homeManager) users);

          }
        ];
      };
      formatter.${system} = pkgs.nixfmt;
    };
}
