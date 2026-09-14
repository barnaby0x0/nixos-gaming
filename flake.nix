{
  description = "NixOS Gaming - CachyOS optimized";

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

        specialArgs = {
          inherit self;
        };

        modules = [
          {
            nixpkgs.overlays = [
              nix-cachyos-kernel.overlays.pinned
            ];
          }

          ./hosts/gaming
        ];
      };
    };
}
