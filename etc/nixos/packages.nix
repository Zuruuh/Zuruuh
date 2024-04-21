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
    unstable.bun
    unstable.cargo
    unstable.cargo-binstall
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
    gpp
    go
    grpcurl
    htop
    jq
    just
    kubectl
    kubernetes
    lua
    gnumake
    man
    mdcat
    minikube
    mkpasswd
    neovim-nightly
    nixpkgs-fmt
    nodejs_21
    nodePackages.eslint
    nodePackages.neovim
    nodePackages.pnpm
    nodePackages.prettier
    unstable.nushell
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
    speedtest-cli
    starship
    stow
    stylua
    sudo
    symfony-cli
    tailspin
    taplo
    tlrc
    unstable.topgrade
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
