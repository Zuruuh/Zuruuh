# Edit this configuration file to define what should be installed on your system. Help
# is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{ imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  environment.systemPackages = with pkgs; [
    amber
    bat
    cmake
    git
    gcc
    gpp
    fd
    fnm
    fzf
    glow
    gh
    go
    htop
    jq
    just
    lua
    man
    neofetch
    neovim-nightly
    openssh
    php82
    php82Packages.composer
    python313Full
    ripgrep
    rustup
    starship
    stow
    sudo
    symfony-cli
    tlrc
    unzip
    wget
    xh
    zip
    zstd
  ];

  wsl = {
    enable = true;
    defaultUser = "zuruh";
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };

  virtualisation.docker.enable = true;
  programs.nix-ld.enable = true;

  users.users.zuruh = {
    extraGroups = [ "docker" ];
    # shell = "/home/zuruh/.cargo/bin/nu";
  };


  # This value determines the NixOS release from which the default settings for
  # stateful data, like file locations and database versions on your system were taken.
  # It's perfectly fine and recommended to leave this value at the release version of
  # the first install of this system. Before changing this value read the documentation
  # for this option (e.g. man configuration.nix or on
  # https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
