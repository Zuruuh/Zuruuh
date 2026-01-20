{ pkgs, outputs, ... }:
let
  platform = "aarch64-darwin";
  username = "YZiadi";
  env = (import ./env.nix { inherit pkgs; });
  shell = pkgs.writeShellScript "nu" ''
    XDG_CONFIG_HOME=${env.XDG_CONFIG_HOME} exec ${pkgs.unstable.nushell}/bin/nu "$@";
  '';
in
{
  services = {
    skhd = {
      enable = true;
      skhdConfig = ''
        # Mapping ctrl+[motion] to alt+[motion]
        ctrl - delete : skhd -k "alt - delete" ctrl - backspace : skhd -k "alt - backspace"
        ctrl - left : skhd -k "alt - left"
        ctrl - right : skhd -k "alt - right"
        ctrl + shift - left : skhd -k "alt + shift - left"
        ctrl + shift - right : skhd -k "alt + shift - right"

        # Mapping Ctrl+[action] to Cmd+[action]
        ctrl - a : skhd -k "cmd - a"  # select all
        ctrl - z : skhd -k "cmd - z"  # undo
        ctrl + shift - z : skhd -k "cmd + shift - z"  # redo

        # Copy/paste/cut commands
        # Set default ctrl+c behavior in ghostty
        ctrl - c [
            "ghostty" ~
            * : skhd -k "cmd - c";
        ]
        ctrl - v : skhd -k "cmd - v" # paste
        ctrl - x : skhd -k "cmd - x" # cut

        # Disable cmd+tab (from simple_modifications)
        # cmd - tab : :
        cmd - h : skhd -k "ctrl - h"
      '';
    };

    aerospace = {
      enable = true;
      settings = {
        # You can use it to add commands that run after login to macOS user session.
        # 'start-at-login' needs to be 'true' for 'after-login-command' to work
        # Available commands: https://nikitabobko.github.io/AeroSpace/commands
        after-login-command = [ ];

        # You can use it to add commands that run after AeroSpace startup.
        # 'after-startup-command' is run after 'after-login-command'
        # Available commands : https://nikitabobko.github.io/AeroSpace/commands
        after-startup-command = [ ];

        # Start AeroSpace at login
        ## Required to be false when not using home manager
        start-at-login = false;

        # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;

        # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
        # The 'accordion-padding' specifies the size of accordion padding
        # You can set 0 to disable the padding feature
        accordion-padding = 0;

        # Possible values: tiles|accordion
        default-root-container-layout = "tiles";

        # Possible values: horizontal|vertical|auto
        # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
        #               tall monitor (anything higher than wide) gets vertical orientation
        default-root-container-orientation = "auto";

        # Mouse follows focus when focused monitor changes
        # Drop it from your config, if you don't like this behavior
        # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
        # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
        # Fallback value (if you omit the key): on-focused-monitor-changed = []
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

        # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key Also see: https://nikitabobko.github.io/AeroSpace/goodness#disable-hide-app automatically-unhide-macos-hidden-apps = true

        # Possible values: (qwerty|dvorak)
        # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
        key-mapping.preset = "qwerty";

        # Gaps between windows (inner-*) and between monitor edges (outer-*).
        # Possible values:
        # - Constant:     gaps.outer.top = 8
        # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
        #                 In this example, 24 is a default value when there is no match.
        #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
        #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
        gaps = {
          inner.horizontal = 16;
          inner.vertical = 16;
          outer.left = 16;
          outer.bottom = 16;
          outer.top = 16;
          outer.right = 16;
        };

        # 'main' binding mode declaration
        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        # 'main' binding mode must be always presented
        # Fallback value (if you omit the key): mode.main.binding = {}
        mode = {

          main.binding = {
            cmd-h = [ ];
            cmd-alt-h = [ ];

            # All possible keys:
            # - Letters.        a, b, c, ..., z
            # - Numbers.        0, 1, 2, ..., 9
            # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
            # - F-keys.         f1, f2, ..., f20
            # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
            #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
            # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
            #                   keypadMinus, keypadMultiply, keypadPlus
            # - Arrows.         left, down, up, right

            # All possible modifiers: cmd, alt, ctrl, shift

            # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

            # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
            # You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
            # alt-enter = '''exec-and-forget osascript -e '
            # tell application "Terminal"
            #     do script
            #     activate
            # end tell'
            # '''

            # See: https://nikitabobko.github.io/AeroSpace/commands#layout
            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            # See: https://nikitabobko.github.io/AeroSpace/commands#focus
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#move
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#resize
            alt-shift-minus = "resize smart -50";
            alt-shift-equal = "resize smart +50";

            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-4 = "workspace 4";
            alt-5 = "workspace 5";
            alt-6 = "workspace 6";
            alt-7 = "workspace 7";
            alt-8 = "workspace 8";
            alt-9 = "workspace 9";
            alt-a = "workspace A"; # In your config, you can drop workspace bindings that you don't need
            alt-b = "workspace B";
            alt-d = "workspace D";
            alt-g = "workspace G";
            alt-i = "workspace I";
            alt-m = "workspace M";
            alt-n = "workspace N";
            alt-o = "workspace O";
            alt-p = "workspace P";
            alt-q = "workspace Q";
            alt-r = "workspace R";
            alt-s = "workspace S";
            alt-t = "workspace T";
            alt-u = "workspace U";
            alt-v = "workspace V";
            alt-w = "workspace W";
            alt-x = "workspace X";
            alt-y = "workspace Y";
            alt-z = "workspace Z";

            # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
            alt-shift-1 = "move-node-to-workspace 1";
            alt-shift-2 = "move-node-to-workspace 2";
            alt-shift-3 = "move-node-to-workspace 3";
            alt-shift-4 = "move-node-to-workspace 4";
            alt-shift-5 = "move-node-to-workspace 5";
            alt-shift-6 = "move-node-to-workspace 6";
            alt-shift-7 = "move-node-to-workspace 7";
            alt-shift-8 = "move-node-to-workspace 8";
            alt-shift-9 = "move-node-to-workspace 9";
            alt-shift-a = "move-node-to-workspace A";
            alt-shift-b = "move-node-to-workspace B";
            alt-shift-d = "move-node-to-workspace D";
            alt-shift-g = "move-node-to-workspace G";
            alt-shift-i = "move-node-to-workspace I";
            alt-shift-m = "move-node-to-workspace M";
            alt-shift-n = "move-node-to-workspace N";
            alt-shift-o = "move-node-to-workspace O";
            alt-shift-p = "move-node-to-workspace P";
            alt-shift-q = "move-node-to-workspace Q";
            alt-shift-r = "move-node-to-workspace R";
            alt-shift-s = "move-node-to-workspace S";
            alt-shift-t = "move-node-to-workspace T";
            alt-shift-u = "move-node-to-workspace U";
            alt-shift-v = "move-node-to-workspace V";
            alt-shift-w = "move-node-to-workspace W";
            alt-shift-x = "move-node-to-workspace X";
            alt-shift-y = "move-node-to-workspace Y";
            alt-shift-z = "move-node-to-workspace Z";

            # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
            alt-tab = "workspace-back-and-forth";
            # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
            alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

            # See: https://nikitabobko.github.io/AeroSpace/commands#mode
            alt-shift-semicolon = "mode service";
          };

          # 'service' binding mode declaration.
          # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
          service.binding = {
            esc = [ "reload-config" "mode main" ];
            r = [ "flatten-workspace-tree" "mode main" ]; # reset layout
            f = [
              "layout floating tiling"
              "mode main"
            ]; # Toggle between floating and tiling layout
            backspace = [ "close-all-windows-but-current" "mode main" ];

            # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
            #s = ['layout sticky tiling', 'mode main']

            alt-shift-h = [ "join-with left" "mode main" ];
            alt-shift-j = [ "join-with down" "mode main" ];
            alt-shift-k = [ "join-with up" "mode main" ];
            alt-shift-l = [ "join-with right" "mode main" ];
          };
        };
      };
    };

    jankyborders = {
      enable = true;
      style = "round";
      width = 10.0;
      hidpi = true;
      active_color = "0xFFFFA500";
      inactive_color = "0xC02C2E34";
      background_color = "0x302C2E34";
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs = {
    inherit pkgs;
  };


  environment = {
    shells = [ shell ];
    variables = env;
    systemPackages = with pkgs; [
      unstable.spicetify-cli
      brave
      google-chrome
      libreoffice-bin
      telegram-desktop
      # ghostty # broken
      postman
      jetbrains.datagrip
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  users = {
    knownUsers = [ username ];
    users.${username} = {
      inherit shell;
      uid = 503;
    };
  };

  programs = {
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };

  system = {
    primaryUser = username;
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
          # both datagrip and postman are added automatically for some reason ?
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
    onActivation.cleanup = "zap";

    casks = [
      "ghostty"
      "ungoogled-chromium"
      "obs"
      "obsidian"
      "orbstack"
      "parsec"
      "proxyman"
      "shottr"
      "slack"
      "proton-pass"
      "proton-drive"
      "proton-mail"
      "protonvpn"
      "zen"
      "spotify"
      "trae"
      "steam"
    ];
  };
}
