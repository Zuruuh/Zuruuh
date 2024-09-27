# Edit this configuration file to define what should be installed on your system. Help
# is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ ... }: {
  imports = [
    <nixos-wsl/modules>
    ./default.nix
    ./packages.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "zuruh";
    wslConf = {
      interop.appendWindowsPath = false;
    };
  };

  # do not touch =D
  system.stateVersion = "23.11";
}
