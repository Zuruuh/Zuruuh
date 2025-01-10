{
  description = "My NixOS system flake";

  inputs = {
    # Packages
    nixos.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Helpers
    flake-compat = {
      url = "github:edolstra/flake-compat/ff81ac966bb2cae68946d5ed5fc4994f96d0ffec";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b";

    # Neovim
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay/177f38b4172b316a48f9ec5b41907b0ad7e0909f";
      inputs.flake-compat.follows = "flake-compat";
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
      url = "github:LnL7/nix-darwin/57733bd1dc81900e13438e5b4439239f1b29db0e";
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
    sbar-lua = {
      url = "github:FelixKratz/SbarLua/437bd2031da38ccda75827cb7548e7baa4aa9978";
      flake = false;
    };
    uuidgen7 = {
      url = "github:Zuruuh/uuidgen/d0cb84f4ff4b9748047d28ba136029066fba2a10";
      inputs = {
        nixpkgs.follows = "nixos";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = inputs@{ self, nixos, nixos-unstable, neovim-nightly-overlay, nixos-wsl, nix-darwin, nix-homebrew, mac-app-util, sbar-lua, ... }:
    let
      root-overlay = final: prev: {
        unstable = import nixos-unstable {
          system = prev.system;
        };
        uuidgen7 = inputs.uuidgen7.outputs.packages.${prev.system}.default;
      };

      overlays = [ root-overlay neovim-nightly-overlay.overlays.default ];
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
                  inherit system overlays;
                  config.allowUnfree = true;
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
            inherit system overlays;
            config.allowUnfree = true;
          };
        in
        {
          "STM-MBTech25" = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit pkgs sbar-lua system;
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
