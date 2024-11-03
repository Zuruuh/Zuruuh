# -- vim: sw=2
{ lib, pkgs, ... }:
let
  forLinux = packages: (if pkgs.stdenv.isDarwin then [ ] else packages);
  php83 = pkgs.php83.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      apcu
      amqp
      pcov
      redis
      xsl
    ]));
    extraConfig = /*toml*/ ''
      apc.enabled=1
      apc.enable_cli=1
      error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
      memory_limit = 512M
    '';
  };
  nodejs = pkgs.nodejs_22;
  nodePackages = pkgs.nodePackages.override {
    inherit nodejs;
  };

  packages = with pkgs; {
    yaml = [
      yaml-language-server
      unstable.vacuum-go
    ];
    rust = [
      cargo-audit
      cargo-binstall
      cargo-expand
      cargo-generate
      cargo-info
      cargo-tarpaulin
      rustup
    ];
    javascript = [
      unstable.bun
      unstable.deno
      nodejs
      nodePackages.pnpm
      nodePackages.serve
      unstable.biome
      unstable.typescript-language-server
      unstable.svelte-language-server
      unstable.astro-language-server
      vscode-langservers-extracted
    ];
    docker = [
      docker-compose-language-service
      dockerfile-language-server-nodejs
    ] ++ forLinux [ pkgs.kubernetes pkgs.kubectl pkgs.minikube ];
    git = [
      gh
      git
      git-lfs
      delta
      gnupg
    ];
    nix = [
      nil
      nixpkgs-fmt
    ];
    c = [
      gcc
      cmake
      gnumake
      gpp
      pkg-config
      unstable.llvmPackages_19.clang-tools
    ] ++ forLinux [ pkgs.libgcc ];
    php = [
      unstable.frankenphp
      unstable.phpactor
      php83
      php83.packages.composer
      php83.packages.phpstan
      php83.packages.php-cs-fixer
      php83.packages.psalm
      symfony-cli
    ];
    python = [
      python312Full
      python312Packages.pynvim
      python312Packages.pip
    ];
    java = [
      zulu17
    ];
    go = [
      unstable.go
      unstable.gopls
    ];
    bash = [
      shellcheck
      shfmt
      unstable.bash-language-server
    ];
    lua = [
      taplo
      lua
      stylua
      lua-language-server
    ];
    http = [
      curl
      wget
      xh
    ];
    json = [
      fx
      jq
    ];
    compression = [
      gzip
      zstd
      brotli
      unzip
      zip
    ];
    search = [
      amber
      fd
      fzf
      ripgrep
    ];
    pretty = [
      bat
      mdcat
      tailspin
      eza
      onefetch
      fastfetch
    ];
    monitoring = [
      btop
      du-dust
    ];
    clipboard = [
      clipboard-jh
      xclip
    ];
    database = [
      sqlx-cli
      valkey
      sqls
    ];
    tools = [
      unstable.typos
      mkpasswd
      man
      openssh
      stow
      tlrc
      tokei
      topgrade
      viu
      yazi
    ] ++ forLinux [ pkgs.sudo ];
    shell = [
      zoxide
      unstable.nushell
      starship
      atuin
      carapace
    ];
    dev = [
      unstable.neovim
      tree-sitter
      unstable.zellij
      just
    ];
    xml = [
      lemminx
    ];
  };
in
{
  environment.systemPackages = lib.concatLists (lib.attrValues packages);
}
