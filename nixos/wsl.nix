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

  environment.systemPackages = [
    (createWindowsBashAlias "reg")
    (createWindowsBashAlias "findstr")
  ];

  # do not touch =D
  system.stateVersion = "23.11";
}
