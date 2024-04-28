```sh
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --update
nix-shell -p git openssh neovim stow gh
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/github"
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/vps"
git clone https://github.com/Zuruuh/Zuruuh ~/.dotfiles
cd ~/.dotfiles
# git switch nixos-2
git remote set-url origin git@github.com:Zuruuh/Zuruuh
# Set correct os.nix file
# example with wsl.nix
ln -s root/etc/nixos/wsl.nix root/etc/nixos/configuration.nix
bash stow.sh
sudo nixos-rebuild switch

# rust/cargo
rustup install nightly
rustup default nightly

sudo reboot
# login as root
passwd <user>
```
