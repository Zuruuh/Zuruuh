inputs@{ pkgs, lib, outputs, config, ... }:
let
  platform = "aarch64-darwin";
  username = "YZiadi";
  shell = pkgs.writeShellScript "nu" ''
    XDG_CONFIG_HOME=${(import ./env.nix {inherit pkgs;}).XDG_CONFIG_HOME} exec ${pkgs.unstable.nushell}/bin/nu "$@";
  '';
  lua-src = pkgs.lua5_4_compat;
  sbar-lua = pkgs.stdenv.mkDerivation {
    pname = "sbarlua";
    version = "437bd2031da38ccda75827cb7548e7baa4aa9979";
    buildInputs = with pkgs; [ gnumake readline gcc lua-src makeWrapper ];
    src = inputs.sbar-lua;
    buildPhase = ''
      build_dir="$(pwd)/build"
      mkdir -p $build_dir
      ${pkgs.gnumake}/bin/make INSTALL_DIR="$build_dir" install
    '';

    installPhase =
      let lua-lib-path = "${lua-src}/lib/lua/5.4";
      in /*bash*/ ''
        mkdir -p $out/share/lua
        cp -r build/* $out/share/lua
        mkdir -p $out/bin
        makeWrapper \
          ${lua-src}/bin/lua \
          $out/bin/sbar-lua \
          --set LUA_CPATH "${lua-lib-path}/?.so;${lua-lib-path}/loadall.so;$out/share/lua/sketchybar.so;./?.so;;" \
          --set LUA_PATH "${lua-lib-path}/?.lua;${lua-lib-path}/loadall.lua;$out/share/lua/sketchybar.lua;./?.lua;;"
      '';
  };
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
    ] ++ [ lua-src sbar-lua ];
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
      sketchybar = makeProgram {
        name = "sketchybar";
        package = pkgs.sketchybar;
        script = /*bash*/ ''
          ${pkgs.sketchybar}/bin/sketchybar
        '';
        environment = {
          API_KEY_FILE = "${env.XDG_DATA_HOME}/idf-mobilites-api-key.txt";
        };
      };
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

    enableRosetta = true;
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
      {
        name = "FelixKratz/formulae/sketchybar";
        start_service = false;
      }
      "switchaudio-osx"
      "nowplaying-cli"
      "blueutil"
    ];

    casks = [
      "orbstack"
      "bitwarden"
      "datagrip"
      "slack"
      "ghostty"
      "sf-symbols"
      "font-sf-mono"
      "font-sf-pro"
      "parsec"
      "wkhtmltopdf"
      "postman"
      "nikitabobko/tap/aerospace"
      "flameshot"
      "pika"
      "eloston-chromium"
      "obs"
      "whatsapp"
      "proxyman"
      "obsidian"
    ];
  };
}
