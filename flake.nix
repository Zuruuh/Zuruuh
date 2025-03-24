{
  description = "My NixOS system flake";

  inputs = {
    # Packages
    nixos.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Helpers
    flake-compat = {
      url = "github:edolstra/flake-compat/ff81ac966bb2cae68946d5ed5fc4994f96d0ffec";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";

    # Neovim
    neovim-src = {
      url = "github:neovim/neovim/b288fa8d62c3f129d333d3ea6abc3234039cad37";
      flake = false;
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay/af9d81d77c8b81856a2d56048c8cb48e98bb929e";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-compat.follows = "flake-compat";
        neovim-src.follows = "neovim-src";
      };
    };

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/63c3b4ed1712a3a0621002cd59bfdc80875ecbb0";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-compat.follows = "flake-compat";
      };
    };

    # MacOS
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixos";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew/a6d99cc7436fc18c097b3536d9c45c0548c694c8";
      inputs = {
        nixpkgs.follows = "nixos";
        nix-darwin.follows = "nix-darwin";
      };
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util/548672d0cb661ce11d08ee8bde92b87d2a75c872";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs = inputs@{ self, nixos, neovim-nightly-overlay, nixos-wsl, nix-darwin, nix-homebrew, mac-app-util, ... }:
    let
      root-overlay = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
        };
      };

      overlays = [ root-overlay neovim-nightly-overlay.overlays.default ];
    in
    {
      nixosConfigurations = {
        # sudo nixos-rebuild switch --flake ~/.dotfiles/#wsl
        wsl = nixos.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = rec {
            outputs = self;
            pkgs = import nixos {
              inherit system overlays;
              config.allowUnfree = true;
            };
            inherit (pkgs) lib;
          };

          modules = [
            nixos-wsl.nixosModules.default
            ./nixos/wsl.nix
            ./nixos/packages.nix
          ];
        };
      };

      darwinConfigurations =
        let
          system = "aarch64-darwin";
          pkgs = import nixos {
            inherit system overlays;
            config.allowUnfree = true;
          };
        in
        {
          "STM-MBTech25" = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit pkgs system;
              inherit (pkgs) lib;
              outputs = self;
            };
            modules = [
              nix-homebrew.darwinModules.nix-homebrew
              mac-app-util.darwinModules.default
              ./nixos/packages.nix
              ./nixos/darwin.nix
            ];
          };
        };
    };
}
