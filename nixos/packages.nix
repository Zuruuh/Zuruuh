# -- vim: sw=2
{ lib, pkgs, ... }:
let
  forLinux = packages: (if pkgs.stdenv.isDarwin then [ ] else packages);
  php83 = pkgs.php83.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      # apcu
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
  nodejs = pkgs.unstable.nodejs_23;
  nodePackages = pkgs.nodePackages.override {
    inherit nodejs;
  };

  packages = with pkgs; {
    yaml = [
      yaml-language-server
      vacuum-go
    ];
    rust = [
      cargo-audit
      cargo-binstall
      cargo-expand
      cargo-generate
      cargo-info
      unstable.cargo-outdated
      cargo-tarpaulin
      cargo-udeps
      rustup
    ];
    javascript = [
      unstable.bun
      deno
      nodejs
      nodePackages.pnpm
      nodePackages.serve
      # unstable.biome
      unstable.typescript-language-server
      unstable.svelte-language-server
      unstable.astro-language-server
      vscode-langservers-extracted
    ];
    docker = [
      dockerfile-language-server-nodejs
      dive
    ] ++ forLinux (with pkgs; [ kubernetes kubectl minikube ]);
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
      nh
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
      unstable.phpactor
      php83
      php83.packages.composer
      php83.packages.php-cs-fixer
      symfony-cli
    ];
    python = [
      python312Full
      python312Packages.pip
      uv
    ];
    java = [
      zulu17
    ];
    go = [
      go
      gopls
    ];
    bash = [
      shellcheck
      shfmt
      bash-language-server
      bashInteractive
    ];
    lua = [
      taplo
      stylua
      lua-language-server
    ];
    http = [
      curl
      wget
      xh
      bruno-cli
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
      # Valkey build breaks for now, see https://hydra.nixos.org/build/291419199
      # valkey
      sqls
    ];
    tools = [
      typos
      mkpasswd
      man
      openssh
      unstable.sequoia-sq
      stow
      tlrc
      viu
      yazi
    ] ++ forLinux [ pkgs.sudo ];
    shell = [
      unstable.zoxide
      unstable.nushell
      starship
      atuin
      uuidgen7
      carapace
    ];
    dev = [
      (pkgs.wrapNeovim neovim { })
      tree-sitter
      unstable.zellij
      just
      ngrok
    ];
    xml = [
      lemminx
    ];
    terraform = [
      opentofu
      terraform-ls
    ];
    zig = [
      zig
      zls
    ];
  };
in
{
  environment.systemPackages = lib.concatLists (lib.attrValues packages);
}
