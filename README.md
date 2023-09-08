# Dotfiles

my personnal dotfiles config, featuring:

- Tmux
- Neovim
- nushell
- starship prompt
- a lot of other cool stuff

get started with

```bash
git clone git@github.com:Zuruuh/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

## Requirements

stuff that need to be installed differently depending on the os (bcz no easy way to install):

- git
- tmux
- gnu stow
- curl
- go

<details>
    <summary>Debian</summary>

```bash
sudo apt update
# we're going to need some deps after so we download them now
sudo apt install -y git tmux stow curl wget \
    build-essential libssl-dev pkg-config cmake
curl https://dl.google.com/go/go1.21.1.linux-amd64.tar.gz -O
tar -xvf go1.21.1.linux-amd64.tar.gz
sudo mv go /usr/local/
rm go1.21.1.linux-amd64.tar.gz
export PATH="$PATH:/usr/local/go/bin"
```

</details>

and now just brain-dead copy paste everything below

```bash
# Enables custom aliases & snippets depending on host OS
ln -s ./config/nushell/os/<current_os>/config.nu ./config/nushell/os/current.nu

# Symlink all config files
stow .

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain nightly --profile complete --no-modify-path
source "$HOME/.cargo/env"

# Install cargo-binstall
curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

# Install all binaries with binstall when possible
# (go grab a drink)
cargo binstall --verbose --no-confirm \
    stylua taplo-cli nu starship \
    bob-nvim spotify-tui bat amber fnm \
    ripgrep just git-delta fd-find mprocs \
    trunk binstall hyperfine zoxide \
    bacon zellij sccache exa du-dust

# Node
fnm install 18 && fnm default 18 && eval $(fnm env)
npm i -g eslint_d eslint @fsouza/prettierd prettier pnpm neovim npm

# Enter nushell to continue installation
nu

go install mvdan.cc/sh/v3/cmd/shfmt@latest \
    github.com/rs/curlie@latest \
    github.com/charmbracelet/glow@latest

# Neovim
bob install nightly; bob use nightly

# Tmux
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Installation

```bash
# Install tmux plugins
# Once inside tmux, run CTRL+S+I
# tmux

# Plugins should auto-install with lazy.nvim
nvim .
```
