```sh
nix shell nixpkgs#git nixpkgs#openssh nixpkgs#stow
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/github.com"
git clone https://github.com/Zuruuh/Zuruuh ~/.dotfiles
cd ~/.dotfiles
git remote set-url origin git@github.com:Zuruuh/Zuruuh
bash stow.sh
sudo nixos-rebuild switch --flake ~/.dotfiles/#<distro>
# rust/cargo
rustup install nightly
rustup default nightly

sudo reboot
# login as root
passwd <user>
```
