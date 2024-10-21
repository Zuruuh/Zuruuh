{ pkgs, ... }:
let
  createWindowsBashAlias = name: (pkgs.writeShellApplication {
    name = "${name}.exe";
    text = /*bash*/ ''
      /mnt/c/Windows/System32/${name}.exe "$@"
    '';
  });
in
{
  wsl = {
    enable = true;
    defaultUser = "zuruh";
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };

  environment.systemPackages = with pkgs; [
    (createWindowsBashAlias "reg")
    (createWindowsBashAlias "findstr")
    wslu
  ];
  environment.sessionVariables = (import ./env.nix { inherit pkgs; });

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


  security.sudo.wheelNeedsPassword = true;

  # do not touch =D
  system.stateVersion = "23.11";
}
