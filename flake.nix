{
  description = "My NixOS system flake";

  inputs = {
    nixos.url = "github:nixos/nixpkgs?ref=24.05";
    nixos-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL?ref=2405.5.4";
      inputs = {
        nixpkgs.follows = "nixos";
      };
    };
  };

  outputs = { self, nixos, nixos-wsl, nixos-unstable }: {
    nixosConfigurations = {
      # sudo nixos-rebuild switch --flake ~/.dotfiles/#wsl
      wsl = nixos.lib.nixosSystem rec {
        system = "x86_64-linux";

        modules =
          let
            args = rec {
              pkgs = import nixos { inherit system; };
              unstable = import nixos-unstable { inherit system; };
              lib = pkgs.lib;
            };
          in
          [
            nixos-wsl.nixosModules.default
            (import ./nixos/default.nix args)
            (import ./nixos/wsl.nix args)
            (import ./nixos/packages.nix args)
          ];
      };
    };
  };
}
