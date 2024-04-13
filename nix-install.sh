nix-shell -p git openssh neovim stow
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/github"
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/git.staffmatch.it"
ssh-keygen -t ed25519 -a 64 -f "$HOME/.ssh/vps"
git clone https://github.com/Zuruuh/Zuruuh ~/.dotfiles
cd ~/.dotfiles
# git switch nixos-2
git remote set-url origin git@github.com:Zuruuh/Zuruuh
# ...link dotfiles configuration.nix
# sudo rm -rf /etc/nixos/configuration.nix
# sudo ln "$HOME/.dotfiles/configuration.nix" /etc/nixos/configuration.nix
stow .
sudo nixos-rebuild switch

# rust/cargo
rustup install nightly
rustup default nightly
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
cargo binstall zoxide zellij nu -y
export PATH="$PATH:$HOME/.cargo/bin"

# bun
curl -fsSL https://bun.sh/install | bash

# node
eval "$(fnm env)"
fnm install 20
fnm default 20
fnm use 20
