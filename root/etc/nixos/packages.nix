{ /*config, lib,*/ pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  php82 = pkgs.php82.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      apcu
      amqp
      redis
      xsl
    ]));
    extraConfig = ''
      apc.enabled=1
      apc.enable_cli=1
      error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
    '';
  };
in
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  environment.systemPackages = with pkgs; [
    amber
    bat
    unstable.biome
    brotli
    unstable.bun
    unstable.cargo
    unstable.cargo-binstall
    cargo-info
    cmake
    delta
    unstable.deno
    du-dust
    eget
    eslint_d
    fastfetch
    fd
    unstable.frankenphp
    fx
    fzf
    gh
    git
    gcc
    gnumake
    gpp
    go
    gradle
    grpcurl
    gzip
    unstable.hexyl
    htop
    jq
    just
    kubectl
    kubernetes
    libgcc
    lua
    unstable.lychee
    man
    mdcat
    minikube
    mkpasswd
    nasm
    neovim-nightly
    nixpkgs-fmt
    nodejs_21
    nodePackages.eslint
    nodePackages.neovim
    nodePackages.pnpm
    nodePackages.prettier
    nodePackages.serve
    unstable.nushell
    onefetch
    openssh
    openssl_3_1
    php82
    php82.packages.composer
    php82Packages.composer
    pkg-config
    prettierd
    protobuf
    unstable.python312Full
    unstable.python312Packages.pynvim
    unstable.python312Packages.pip
    ripgrep
    unstable.rustup
    shellcheck
    shfmt
    sqlx-cli
    starship
    stow
    stylua
    sudo
    symfony-cli
    tailspin
    taplo
    tlrc
    unstable.typos
    unstable.topgrade
    tree-sitter
    unzip
    viu
    wget
    xclip
    xh
    unstable.zellij
    zip
    unstable.zoxide
    zstd
    zulu17
  ];
}
