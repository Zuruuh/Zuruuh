{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  environment.systemPackages = with pkgs; [
    amber
    bat
    unstable.biome
    unstable.bun
    unstable.cargo
    unstable.cargo-binstall
    cmake
    delta
    eslint_d
    fd
    fx
    fzf
    glow
    gh
    git
    gcc
    gpp
    go
    htop
    jq
    just
    lua
    man
    neofetch
    neovim-nightly
    nodejs_21
    nodePackages.eslint
    nodePackages.neovim
    nodePackages.pnpm
    nodePackages.prettier
    unstable.nushell
    openssh
    openssl_3_1
    php82
    php82Packages.composer
    pkg-config
    prettierd
    unstable.python312Full
    unstable.python312Packages.pynvim
    unstable.python312Packages.pip
    ripgrep
    unstable.rustup
    shellcheck
    shfmt
    starship
    stow
    stylua
    sudo
    symfony-cli
    tailspin
    taplo
    tlrc
    topgrade
    tree-sitter
    unzip
    wget
    xclip
    xh
    unstable.zellij
    zip
    unstable.zoxide
    zstd
  ];
}
