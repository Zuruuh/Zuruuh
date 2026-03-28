{
  description = "My NixOS system flake";

  inputs = {
    # Packages
    nixos.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Helpers
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixos";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";

    # CLIs
    behat-lsp = {
      url = "github:Zuruuh/behat-lsp?ref=main";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-utils.follows = "flake-utils";
      };
    };
    vimfony = {
      url = "github:shinyvision/vimfony?ref=main";
      flake = false;
    };
    phpantom = {
      url = "github:AJenbo/phpantom_lsp?ref=0.6.0";
      flake = false;
    };

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.11";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-compat.follows = "flake-compat";
      };
    };

    # MacOS
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
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
      root-overlay = final: prev:
        let
          system = prev.stdenv.hostPlatform.system;
        in
        {
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          behat-lsp = inputs.behat-lsp.packages.${system}.default;
          vimfony = (pkgs: pkgs.buildGoModule {
            pname = "vimfony";
            version = "0.1.1";
            vendorHash = "sha256-NvEBp3iSLv+UipQ8xfUN151jlzPndUPob3tnFhUsn98=";
            buildTestBinaries = false;
            doCheck = false;

            src = inputs.vimfony;
          });

          phpantom = (pkgs:
            let
              toolchain = inputs.fenix.packages.${system}.fromToolchainName {
                name = "nightly";
                sha256 = "sha256-XLL6/CdeXqrWICWZt2lnbzhUX7yk0iHHDd7V6ZqBeRY=";
              };
              rustPlatform = pkgs.makeRustPlatform {
                inherit (toolchain) cargo rustc;
              };
            in
            rustPlatform.buildRustPackage {
              pname = "phpantom_lsp";
              version = inputs.phpantom.shortRev;
              doCheck = false;

              src = inputs.phpantom;
              cargoHash = "sha256-oRjXf1zR0Ajot6l6ljNAfT7o9yi8m9v8Iwc2xBlTxHM=";
            });
        };
      global-nodejs = (final: prev:
        let
          nodejs = final.nodejs_24;
        in
        {
          inherit nodejs;
          nodejs-slim = nodejs;
        });

      overlays = [
        root-overlay
        global-nodejs
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
