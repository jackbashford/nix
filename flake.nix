{
  description = "Desktop NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    nixosConfigurations = {
      deskmiddle = {
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            vars.user = "jack";
          };
          modules = [
            ./hosts/deskmiddle/configuration.nix
          ];
        };
      };
    };
  };
}
