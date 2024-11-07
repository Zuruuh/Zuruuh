{ pkgs, ... }: rec {
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_CONFIG_HOME = "$HOME/.dotfiles/home/.config";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  EDITOR = "${pkgs.unstable.neovim}/bin/nvim";
  PAGER = "${pkgs.less}/bin/less -R";
  LANG = "en_US.UTF-8";
  LC_ALL = LANG;
}