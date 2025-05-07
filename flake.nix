{
  description = "My NixOS system flake";

  inputs = {
    # Packages
    nixos.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Helpers
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/394c77f61ac76399290bfc2ef9d47b1fba31b215";
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

  outputs = inputs@{ self, nixos, nixos-wsl, nix-darwin, nix-homebrew, mac-app-util, ... }:
    let
      root-overlay = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
        };
      };
      global-nodejs-24 = (final: prev:
        let
          nodejs = final.unstable.nodejs_24;
        in
        {
          inherit nodejs;
          nodejs-slim = nodejs;
        });

      overlays = [
        root-overlay
        global-nodejs-24
      ];
    in
    {
      # sudo nixos-rebuild switch --flake ~/.dotfiles/#wsl
      nixosConfigurations.wsl = nixos.lib.nixosSystem rec {
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
