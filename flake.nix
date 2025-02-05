{
  description = "Desktop NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    helix.url = "github:helix-editor/helix/master";
    helix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      ...
    }@inputs:
    {

      nixosConfigurations = {
        deskmiddle = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            vars.user = "jack";
          };
          modules = [
            ./hosts/deskmiddle/configuration.nix
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
        eepsilon = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            vars.user = "jack";
          };
          modules = [
            ./hosts/eepsilon/configuration.nix
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
      };
    };
}
