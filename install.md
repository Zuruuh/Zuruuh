```sh
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
sudo nix-channel --update
nix-shell -p git openssh neovim stow gh
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/github"
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/git.staffmatch.it"
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/vps"
git clone https://github.com/Zuruuh/Zuruuh ~/.dotfiles
cd ~/.dotfiles
# git switch nixos-2
git remote set-url origin git@github.com:Zuruuh/Zuruuh
# ...link dotfiles configuration.nix
# sudo rm -rf /etc/nixos/configuration.nix
# sudo ln "$HOME/.dotfiles/etc/nixos/wsl.nix" /etc/nixos/configuration.nix
# sudo ln "$HOME/.dotfiles/etc/nixos/packages.nix" /etc/nixos/packages.nix
stow .
sudo nixos-rebuild switch

# rust/cargo
rustup install nightly
rustup default nightly

# restart shell
```
