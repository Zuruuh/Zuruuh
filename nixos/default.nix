{ pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  virtualisation.docker.enable = true;

  programs = {
    nix-ld.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };

  users.users = {
    zuruh = {
      isNormalUser = true;
      extraGroups = [ "docker" ];
      shell = pkgs.unstable.nushell;
    };
    root = { };
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.dotfiles/home/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    EDITOR = "${pkgs.unstable.neovim}/bin/nvim";
    PAGER = "${pkgs.less}/bin/less";
  };

  security.sudo.wheelNeedsPassword = true;
}
