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
    cargo-binstall
    cmake
    delta
    git
    gcc
    gpp
    fd
    nodejs_21
    eslint_d
    fx
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
    python312Full
    unstable.python312Packages.pynvim
    unstable.python312Packages.pip
    ripgrep
    rustup
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
    xh
    unstable.zellij
    zip
    unstable.zoxide
    zstd
  ];
}
