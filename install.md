```sh
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --update
nix-shell -p git openssh neovim stow gh
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/github.com"
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/vps"
git clone https://github.com/Zuruuh/Zuruuh ~/.dotfiles
cd ~/.dotfiles
git remote set-url origin git@github.com:Zuruuh/Zuruuh
bash stow.sh
sudo nixos-rebuild switch

# rust/cargo
rustup install nightly
rustup default nightly

sudo reboot
# login as root
passwd <user>
```
