# -- vim: sw=2
{ lib, pkgs, ... }:
let
  forLinux = packages: (if pkgs.stdenv.isDarwin then [ ] else packages);
  php84 = pkgs.next.php84.buildEnv {
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
  nodejs = pkgs.nodejs_22;
  nodePackages = pkgs.nodePackages.override {
    inherit nodejs;
  };

  packages = with pkgs; {
    yaml = [
      yaml-language-server
      next.vacuum-go
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
      next.deno
      nodejs
      nodePackages.pnpm
      nodePackages.serve
      unstable.biome
      unstable.typescript-language-server
      unstable.svelte-language-server
      unstable.astro-language-server
      vscode-langservers-extracted
      unstable.wrangler
    ];
    docker = [
      docker-compose-language-service
      dockerfile-language-server-nodejs
    ] ++ forLinux [ pkgs.kubernetes pkgs.kubectl pkgs.minikube ];
    git = [
      gh
      git
      git-lfs
      next.delta
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
      unstable.phpactor
      php84
      php84.packages.composer
      php84.packages.php-cs-fixer
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
      next.go
      next.gopls
    ];
    bash = [
      shellcheck
      shfmt
      next.bash-language-server
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
      next.bruno-cli
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
      next.typos
      mkpasswd
      man
      openssh
      stow
      tlrc
      tokei
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
      ngrok
    ];
    xml = [
      lemminx
    ];
  };
in
{
  environment.systemPackages = lib.concatLists (lib.attrValues packages);
}
