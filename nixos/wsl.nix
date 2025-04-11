{ pkgs, config, ... }:
let
  createWindowsBashAlias = name: (pkgs.writeShellApplication {
    name = "${name}.exe";
    text = /*bash*/ ''
      /mnt/c/Windows/System32/${name}.exe "$@"
    '';
  });
  user = "zuruh";
in
{
  wsl = {
    enable = true;
    defaultUser = user;
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      (createWindowsBashAlias "reg")
      (createWindowsBashAlias "findstr")
      wslu
    ];
    sessionVariables = (import ./env.nix { inherit pkgs; });
    etc."current-system-packages".text =
      let
        packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
        sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      in
      builtins.concatStringsSep "\n" sortedUnique;
  };

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
    command-not-found.enable = false;
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
    shell = pkgs.unstable.nushell;
  };
  users.users.root = { };

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "24.11";
  system.userActivationScripts.buildBatCache = {
    text = /*sh*/ ''
      ${pkgs.bat}/bin/bat cache --build
    '';
    deps = [ pkgs.bat ];
  };
}
