{ pkgs, ... }: {
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_CONFIG_HOME = "$HOME/.dotfiles/home/.config";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  EDITOR = "${pkgs.unstable.neovim}/bin/nvim";
  PAGER = "${pkgs.less}/bin/less -R";
}
