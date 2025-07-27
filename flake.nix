{
  description = "My NixOS system flake";

  inputs = {
    # Packages
    nixos.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Helpers
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.05";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-compat.follows = "flake-compat";
      };
    };

    # MacOS
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixos";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
  };

  outputs = inputs@{ self, nixos, nixos-wsl, nix-darwin, mac-app-util, ... }:
    let
      root-overlay = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system;
        };
      };
      global-nodejs-24 = (final: prev:
        let
          nodejs = final.nodejs_24;
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
        specialArgs = {
          inherit inputs;
          outputs = self;
        };

        modules = [
          {
            nixpkgs.pkgs = import nixos {
              inherit system overlays;
              config.allowUnfree = true;
            };
          }
          nixos-wsl.nixosModules.default
          ./nix/wsl.nix
          ./nix/packages.nix
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
          # nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch --flake ~/.dotfiles
          # darwin-rebuild switch --flake ~/.dotfiles
          "STM-MBTech25" = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit pkgs system inputs;
              inherit (pkgs) lib;
              outputs = self;
            };
            modules = [
              inputs.nix-homebrew.darwinModules.nix-homebrew
              mac-app-util.darwinModules.default
              ./nix/packages.nix
              ./nix/darwin.nix
            ];
          };
        };
    };
}
