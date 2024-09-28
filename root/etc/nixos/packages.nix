{ lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };

  php83 = pkgs.php83.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      apcu
      amqp
      pcov
      redis
      xsl
    ]));
    extraConfig = ''
      apc.enabled=1
      apc.enable_cli=1
      error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
    '';
  };
  nodePackages = pkgs.nodePackages.override {
    nodejs = pkgs.nodejs_22;
  };

  packages = {
    yaml = with pkgs; [
      yaml-language-server
    ];
    rust = with pkgs; [
      cargo-audit
      cargo-binstall
      cargo-expand
      cargo-generate
      cargo-info
      cargo-tarpaulin
      rustup
    ];
    javascript = with pkgs; [
      unstable.bun
      unstable.deno
      nodejs_22
      nodePackages.pnpm
      nodePackages.serve
      unstable.biome
      unstable.typescript-language-server
      unstable.svelte-language-server
      unstable.astro-language-server
      vscode-langservers-extracted
    ];
    docker = with pkgs; [
      minikube
      kubectl
      kubernetes
      docker-compose-language-service
      dockerfile-language-server-nodejs
    ];
    git = with pkgs; [
      gh
      git
      git-lfs
      delta
      gnupg
    ];
    nix = with pkgs; [
      nil
      nixpkgs-fmt
    ];
    c = with pkgs; [
      gcc
      cmake
      gnumake
      gpp
      libgcc
      pkg-config
      unstable.llvmPackages_19.clang-tools
    ];
    php = with pkgs; [
      unstable.frankenphp
      unstable.phpactor
      php83
      php83.packages.composer
      php83.packages.phpstan
      php83.packages.php-cs-fixer
      php83.packages.psalm
      symfony-cli
    ];
    python = with pkgs; [
      python312Full
      python312Packages.pynvim
      python312Packages.pip
    ];
    java = with pkgs; [
      zulu17
    ];
    go = with pkgs; [
      go
    ];
    bash = with pkgs ;[
      shellcheck
      shfmt
      unstable.bash-language-server
    ];
    lua = with pkgs; [
      taplo
      lua
      stylua
      lua-language-server
    ];
    http = with pkgs; [
      curl
      wget
      xh
    ];
    json = with pkgs; [
      fx
      jq
    ];
    compression = with pkgs; [
      gzip
      zstd
      brotli
      unzip
      zip
    ];
    search = with pkgs; [
      amber
      fd
      fzf
      ripgrep
    ];
    pretty = with pkgs; [
      bat
      mdcat
      tailspin
      eza
      onefetch
      fastfetch
    ];
    monitoring = with pkgs; [
      btop
      du-dust
    ];
    clipboard = with pkgs; [
      clipboard-jh
      xclip
    ];
    database = with pkgs; [
      sqlx-cli
      valkey
      sqls
    ];
    tools = with pkgs; [
      unstable.typos
      mkpasswd
      man
      openssh
      sudo
      stow
      tlrc
      tokei
      topgrade
      viu
      yazi
    ];
    shell = with pkgs;[
      zoxide
      unstable.nushell
      starship
    ];
    dev = with pkgs; [
      unstable.neovim
      tree-sitter
      unstable.zellij
      just
    ];
    xml = with pkgs; [
      lemminx
    ];
  };
in
{
  environment.systemPackages = lib.concatLists (lib.attrValues packages);
}
