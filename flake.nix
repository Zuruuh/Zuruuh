{
  description = "My NixOS system flake";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/f130def404d6c69920ba1c61cb94bdaa9d6fc8f1";
      inputs.nixpkgs.follows = "nixos";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/a35b08d09efda83625bef267eb24347b446c80b8";
      inputs.nixpkgs.follows = "nixos";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew/ac3945ee614f69ab89c6935b3f0567028de5f012";
      inputs = {
        nixpkgs.follows = "nixos";
        nix-darwin.follows = "nix-darwin";
      };
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util/548672d0cb661ce11d08ee8bde92b87d2a75c872";
      inputs.nixpkgs.follows = "nixos";
    };
    sbar-lua = {
      url = "github:FelixKratz/SbarLua/437bd2031da38ccda75827cb7548e7baa4aa9978";
      flake = false;
    };
  };

  outputs = { self, nixos, nixos-unstable, nixos-wsl, nix-darwin, nix-homebrew, mac-app-util, sbar-lua }:
    let
      root-overlay = final: prev: {
        unstable = import nixos-unstable {
          system = prev.system;
        };
      };

      overlays = [ root-overlay ];
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
              lib = pkgs.lib;
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
