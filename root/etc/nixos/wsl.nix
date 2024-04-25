# Edit this configuration file to define what should be installed on your system. Help
# is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ /*config, lib, */ pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports = [
    <nixos-wsl/modules>
    ./packages.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  wsl = {
    enable = true;
    defaultUser = "zuruh";
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };

  virtualisation.docker.enable = true;

  programs = {
    nix-ld.enable = true;
    fish.enable = true;
  };

  users.users = {
    zuruh = {
      isNormalUser = true;
      extraGroups = [ "docker" ];
      shell = unstable.nushell;
    };
    root = {
      shell = pkgs.fish;
    };
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  security.sudo.wheelNeedsPassword = true;

  # do not touch =D
  system.stateVersion = "23.11";
}
