{ pkgs, ... }: rec {
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_CONFIG_HOME = "$HOME/.dotfiles/home/.config";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  EDITOR = "/run/current-system/sw/bin/nvim";
  PAGER = "${pkgs.less}/bin/less -R";
  LANG = "en_US.UTF-8";
  LC_ALL = LANG;

  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}
