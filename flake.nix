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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      nix-cachyos-kernel,
      ...
    }:

    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.gaming = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
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
          ./modules/cachyos.nix
          ./modules/desktop.nix
          ./modules/gaming.nix
          ./modules/performance.nix

          # Home Manager
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.user = import ./home/gaming.nix;
          }
        ];
      };
    };
}
