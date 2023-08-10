{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "zuruh";
  home.homeDirectory = "/home/zuruh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  home.packages = with pkgs; [
    amber
    atuin
    automake
    bat
    bun
    cargo
    cmake
    curlie
    docker
    exa
    fd
    nodejs_18
    nodePackages_latest.pnpm
    fzf
    gh
    glow
    gnumake
    go
    htop
    jq
    just
    libgccjit
    lua
    man
    neofetch
    neovim-nightly
    openssh
    php82
    php82Packages.composer
    python311
    python311Packages.pip
    ripgrep
    spotify-tui
    symfony-cli
    tmux
    unzip
    vagrant
    wget
    zellij
    zip
    zsh

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    
    ".zshrc".source = ../../../dotfiles/.zshrc.ubuntu;
    ".ssh/config".source = ~/dotfiles/.ssh/config;
    ".p10k.zsh".source = ~/dotfiles/.p10k.zsh;
    ".atuin.zsh".source = ~/dotfiles/.atuin.zsh;
    ".config/atuin".source = ~/dotfiles/.config/atuin;
    ".config/nvim".source = ~/dotfiles/.config/nvim;
    ".config/phpactor".source = ~/dotfiles/.config/phpactor;
    ".config/tmux/tmux.conf".source = ~/dotfiles/.config/tmux/.tmux.conf;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/zuruh/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs = {
    git = {
      package = pkgs.gitAndTools.gitFull;
      enable = true;
      userName = "Zuruuh";
      userEmail = "ziadi.mail.pro@gmail.com";

      extraConfig = {
        core = {
          editor = "nvim";
        };
        add = {
          interactive = {
            useBuiltin = false;
          };
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = false;
        };
        init = {
          defaultBranch = "main";
        };
      };
    
      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          line-numbers = true;
          syntax-theme = "GitHub";
        };
      };

      ignores = [
        "/.vscode"
        "/.idea"
        "/*.ignored"
        "/.ignored/"
        "/phpactor"
        "/.phpactor.json"
      ];
    };

    home-manager.enable = true;
  };
}
