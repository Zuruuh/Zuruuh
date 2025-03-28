{
  description = "My NixOS system flake";

  inputs = {
    # Packages
    nixos.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    # Helpers
    flake-compat = {
      url = "github:edolstra/flake-compat/ff81ac966bb2cae68946d5ed5fc4994f96d0ffec";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";

    # Neovim
    # neovim-src = {
    #   url = "github:neovim/neovim/18fa61049a9e19a3e8cbac73d963ac1dac251b39";
    #   flake = false;
    # };
    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay/81b3c44666b9e31920a6dd1de9bc8aa31f5c9b29";
    #   inputs = {
    #     nixpkgs.follows = "nixos";
    #     flake-compat.follows = "flake-compat";
    #     neovim-src.follows = "neovim-src";
    #   };
    # };

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-compat.follows = "flake-compat";
      };
    };

    # MacOS
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixos";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew/04b0536479d2d2e8d71dc8c8ee97c2b61f0c9987";
      inputs = {
        nixpkgs.follows = "nixos";
        nix-darwin.follows = "nix-darwin";
      };
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util/341ede93f290df7957047682482c298e47291b4d";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs = inputs@{ self, nixos, /*neovim-nightly-overlay, */ nixos-wsl, nix-darwin, nix-homebrew, mac-app-util, ... }:
    let
      root-overlay = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
        };
        master = import inputs.nixpkgs-master {
          inherit (prev) system;
        };
      };

      overlays = [
        root-overlay
        # inputs.neovim-nightly-overlay.overlays.default
      ];
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
          # nix run github:nix-darwin/nix-darwin#darwin-rebuild --extra-experimental-features 'nix-command flakes' -- switch --flake ~/.dotfiles
          # nix run nix-darwin/nix-darwin-24.11#darwin-rebuild -- switch --flake ~/.dotfiles
          # darwin-rebuild switch --flake ~/.dotfiles
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
