{ pkgs, lib, outputs, config, ... }:
let
  platform = "aarch64-darwin";
  username = "YZiadi";
  shell = pkgs.writeShellScript "nu" ''
    XDG_CONFIG_HOME=${(import ./env.nix {inherit pkgs;}).XDG_CONFIG_HOME} exec ${pkgs.unstable.nushell}/bin/nu "$@";
  '';
  env = (import ./env.nix { inherit pkgs; });
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
    systemPackages = with pkgs; [
      telegram-desktop
      skhd
      unstable.bruno
    ];
    variables = env;
  };

  fonts.packages = with pkgs; [
    unstable.nerd-fonts.monaspace
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

  launchd.user.agents =
    let
      makeProgram =
        { name
        , package
        , extraPackages ? [ ]
        , script
        , environment ? { }
        }: {
          environment = lib.mkMerge [
            {
              SHELL = "${pkgs.bash}/bin/bash";
            }
            environment
          ];
          path = config.environment.systemPackages
            ++ [ pkgs.bash package ]
            ++ extraPackages
            ++ [ "/opt/homebrew/bin" "/usr/bin" "/usr/sbin" "/bin" ];
          serviceConfig = {
            RunAtLoad = true;
            KeepAlive = {
              SuccessfulExit = false;
              Crashed = true;
            };
            StandardOutPath = "/tmp/${name}_${username}.out.log";
            StandardErrorPath = "/tmp/${name}_${username}.err.log";
            ProcessType = "Interactive";
          };
          inherit script;
        };
    in
    {
      skhd = lib.mkMerge [
        (makeProgram {
          name = "skhd";
          package = pkgs.skhd;
          extraPackages = [ pkgs.jq ];

          script = ''
            ${pkgs.skhd}/bin/skhd -V
          '';
        })
        { serviceConfig.Nice = -20; }
      ];
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
          "/Applications/Ghostty.app"
          "/Applications/Zen Browser.app"
          "/Applications/Slack.app"
          "/Applications/Spotify.app"
          "/Applications/Discord.app"
          "/Applications/OrbStack.app"
          "/Applications/Proton Mail.app"
          "/Applications/DataGrip.app"
          "/Applications/Postman.app"
        ];
      };

      finder = {
        FXPreferredViewStyle = "clmv";
        QuitMenuItem = true;
        ShowPathbar = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        _FXShowPosixPathInTitle = true;
        NewWindowTarget = "Computer";
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

    user = username;
  };

  homebrew = {
    enable = true;
    global.autoUpdate = false;

    brews = [
      "spicetify-cli"
      {
        name = "FelixKratz/formulae/borders";
        start_service = true;
      }
      "switchaudio-osx"
      "nowplaying-cli"
      "blueutil"
      "icu4c@76"
    ];

    casks = [
      "datagrip"
      "ghostty"
      "eloston-chromium"
      "font-sf-mono"
      "font-sf-pro"
      "nikitabobko/tap/aerospace"
      "obs"
      "obsidian"
      "orbstack"
      "parsec"
      "postman"
      "proxyman"
      "sf-symbols"
      "shottr"
      "slack"
      "wkhtmltopdf"
      "libreoffice"
    ];
  };
}
