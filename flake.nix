{
  description = "My NixOS system flake";

  inputs = {
    nixos.url = "github:nixos/nixpkgs?ref=24.05";
    nixos-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL?ref=2405.5.4";
      inputs.nixpkgs.follows = "nixos";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixos";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs = {
        nixpkgs.follows = "nixos";
        nix-darwin.follows = "nix-darwin";
      };
    };
  };

  outputs = { self, nixos, nixos-wsl, nixos-unstable, nix-darwin, nix-homebrew }:
    let
      unstable-overlay = final: prev: {
        unstable = import nixos-unstable {
          system = prev.system;
        };
      };
    in
    {
      nixosConfigurations = {
        # sudo nixos-rebuild switch --flake ~/.dotfiles/#wsl
        wsl = nixos.lib.nixosSystem rec {
          system = "x86_64-linux";

          modules =
            let
              args = rec {
                pkgs = import nixos {
                  inherit system;
                  overlays = [ unstable-overlay ];
                };
                lib = pkgs.lib;
              };
            in
            [
              nixos-wsl.nixosModules.default
              (import ./nixos/wsl.nix args)
              (import ./nixos/packages.nix args)
            ];
        };
      };

      darwinConfigurations =
        let
          system = "aarch64-darwin";
          pkgs = import nixos {
            inherit system;
            overlays = [ unstable-overlay ];
          };
          args = {
            inherit pkgs;
            lib = pkgs.lib;
            outputs = self;
          };
        in
        {
          "STM-MBTech25" = nix-darwin.lib.darwinSystem {
            modules = [
              nix-homebrew.darwinModules.nix-homebrew
              (import ./nixos/packages.nix args)
              (import ./nixos/darwin.nix args)
            ];
          };
        };
    };
}
