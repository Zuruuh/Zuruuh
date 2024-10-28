{ pkgs, outputs, ... }:
let
  platform = "aarch64-darwin";
  username = "YZiadi";
  shell = pkgs.writeShellScript "nu" ''
    XDG_CONFIG_HOME=${(import ./env.nix {inherit pkgs;}).XDG_CONFIG_HOME} exec ${pkgs.unstable.nushell}/bin/nu "$@";
  '';
in
{
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs = {
    hostPlatform = platform;

    config.allowUnfree = true;
  };

  environment = {
    shells = [ shell ];
    loginShell = "${shell}/bin/nu";
    systemPackages = with pkgs; [
      alt-tab-macos
      telegram-desktop
      sketchybar
      yabai
      unstable.skhd
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

  launchd.user.agents.skhd = {
    environment = {
      SHELL = "${pkgs.bash}/bin/bash";
    };
    path = [
      pkgs.bash
      pkgs.unstable.skhd
      pkgs.jq
      pkgs.yabai
    ];
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
        Crashed = true;
      };
      StandardOutPath = "/tmp/skhd_${username}.out.log";
      StandardErrorPath = "/tmp/skhd_${username}.err.log";
      ProcessType = "Interactive";
      Nice = -20;
    };
    script = ''
      ${pkgs.unstable.skhd}/bin/skhd -V
    '';
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
        showhidden = false;
        tilesize = 48;
        persistent-apps = [
          "/Applications/Alacritty.app"
          "/Applications/Zen Browser.app"
          "/Applications/Slack.app"
          "/Applications/Spotify.app"
          "/Applications/Discord.app"
          "/Applications/OrbStack.app"
          "/Applications/Proton Mail.app"
          "/Applications/Bitwarden.app"
          "/Applications/DataGrip.app"
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
        InitialKeyRepeat = 15;
        AppleKeyboardUIMode = 3;
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

    global.autoUpdate = false;

    brews = [
      "spicetify-cli"
      {
        name = "FelixKratz/formulae/svim";
        start_service = true;
      }
      {
        name = "FelixKratz/formulae/borders";
        start_service = true;
      }
    ];

    casks = [
      "orbstack"
      "bitwarden"
      "datagrip"
      "slack"
      "alacritty"
    ];
  };
}
