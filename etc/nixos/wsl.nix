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

  wsl = {
    enable = true;
    defaultUser = "zuruh";
    wslConf = {
      interop.appendWindowsPath = false;
      network.generateResolvConf = false;
    };
  };

  virtualisation.docker.enable = true;
  programs.nix-ld.enable = true;

  networking = {
    nameservers = [ "192.168.1.254" "1.1.1.1" ];
    resolvconf = {
      enable = true;
    };
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

  programs.fish.enable = true;

  security.sudo.wheelNeedsPassword = true;

  # do not touch =D
  system.stateVersion = "23.11";
}
