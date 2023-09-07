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
# Symlink all config files
stow .

# Install rust toolchain, make sure you select the following options:
# default host triple: <default>
# default toolchain: nightly
# profile: complete
# modify PATH variable: no
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# Install sccache to speed up the next cargo installs
cargo install sccache
export RUSTC_WRAPPER=$HOME/.cargo/bin/sccache

# go grab a drink :D
# todo: use binstall instead of install here
cargo install stylua taplo-cli nu starship \
    bob-nvim spotify-tui bat exa amber fnm \
    ripgrep just git-delta fd-find mprocs bacon \
    trunk binstall hyperfine

# node
fnm install 18 && fnm default 18 && eval $(fnm env)
npm i -g eslint_d @fsouza/prettierd pnpm neovim npm

go install mvdan.cc/sh/v3/cmd/shfmt@latest \
    github.com/rs/curlie@latest \
    github.com/charmbracelet/glow@latest

# Neovim
bob install nightly; bob use nightly

# TMUX
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Installation

```bash
# Install tmux plugins
tmux
# Once inside tmux, run CTRL+S+I


```
