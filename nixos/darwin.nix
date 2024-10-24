{ pkgs, outputs, ... }:
let
  username = "YZiadi";
  shell = pkgs.writeShellScript "nu" ''
    XDG_CONFIG_HOME=${(import ./env.nix {inherit pkgs;}).XDG_CONFIG_HOME} exec ${pkgs.unstable.nushell}/bin/nu "$@";
  '';
in
{
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment = {
    shells = [ shell ];
    loginShell = "${shell}/bin/nu";
    systemPackages = with pkgs; [
      alacritty
      karabiner-elements
      alt-tab-macos
    ];
    variables = (import ./env.nix { inherit pkgs; });
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "Monaspace" ];
    })
  ];

  users = {
    knownUsers = [ username ];
    users.${username} = {
      inherit shell;
      uid = 503;
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  system = {
    configurationRevision = outputs.rev or outputs.dirtyRev or null;
    stateVersion = 5;

    defaults = {
      dock = {
        autohide = true;
        dashboard-in-overlay = true;
        launchanim = false;
        mineffect = "scale";
        minimize-to-application = true;
        show-recents = false;
        tilesize = 48;
        persistent-apps = [
          "${pkgs.alacritty}/Applications/Alacritty.app"
          "/Applications/Zen Browser.app"
          "/Applications/Slack.app"
          "/Applications/Spotify.app"
          "/Applications/Discord.app"
          "/Applications/OrbStack.app"
          "/Applications/Proton Mail.app"
          "/Applications/Bitwarden.app"
        ];
      };

      finder = {
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
        ShowPathbar = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
      };

      NSGlobalDomain = {
        KeyRepeat = 2;
      };
    };
  };

  nix-homebrew = {
    enable = true;

    enableRosetta = true;
    user = username;
  };

  homebrew = {
    enable = true;

    brews = [
      "spicetify-cli"
    ];

    casks = [
      "orbstack"
      "bitwarden"
      "rectangle"
    ];
  };
}
