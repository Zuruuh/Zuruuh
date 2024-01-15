# Dotfiles

my personnal dotfiles config, featuring:

- Zellij
- Neovim
- nushell
- starship prompt
- a lot of other cool stuff

get started with

```bash
git clone git@github.com:Zuruuh/Zuruuh.git ~/dotfiles
cd ~/dotfiles
```

## Requirements

stuff that need to be installed differently depending on the os (bcz no easy way to install):

- git
- gnu stow
- curl
- go

<details>
    <summary>Debian</summary>

```bash
sudo apt update
# we're going to need some deps after so we download them now
sudo apt install -y git stow curl wget unzip \
    build-essential libssl-dev pkg-config \
    cmake fzf zstd
curl https://go.dev/dl/go1.21.5.linux-amd64.tar.gz -O
tar -xvf go1.21.5.linux-amd64.tar.gz
sudo mv go ~/.local/share/go/
rm go1.21.5.linux-amd64.tar.gz
export PATH="$PATH:~/.local/share/go/bin"
```

</details>

<details>
    <summary>MacOS</summary>

```bash
# First install MacOS developpers toolkit if not done already
# then install homebrew
$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
brew install stow
curl https://go.dev/dl/go1.21.5.darwin-arm64.tar.gz -O
tar -xvf go1.21.5.darwin-arm64.tar.gz
sudo mv go ~/.local/share/go/
rm go1.21.5.darwin-arm64.tar.gz
export PATH="$PATH:~/.local/share/go/bin"
```

</details>

and now just brain-dead copy paste everything below

```bash
cd ~/dotfiles
# Enables custom aliases & snippets depending on host OS
ln -s ./.config/nushell/os/<current_os>/config.nu ./.config/nushell/os/current.nu

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
    ripgrep just git-delta fd-find \
    trunk binstall hyperfine zoxide \
    zellij eza du-dust topgrade \
    skim tokei xh xcp cargo-update tailspin

# Node
fnm install 20 && fnm default 20 && eval $(fnm env)
npm i -g eslint_d eslint @fsouza/prettierd prettier pnpm neovim npm tree-sitter-cli @biomejs/biome

# Bun
curl -fsSL https://bun.sh/install | bash

# Pyenv
curl https://pyenv.run | bash
pyenv install 3.11; pyenv global 3.11
python -m pip install neovim

# Enter nushell to continue installation
nu

[
    mvdan.cc/sh/v3/cmd/shfmt@latest
    github.com/charmbracelet/glow@latest
    github.com/antonmedv/fx@latest
] | each {|package| go install $package}

# Neovim
bob install nightly; bob use nightly
```

## Installation

```bash
# Plugins should auto-install with lazy.nvim
nvim .

# requires php
git clone git@github.com:phpactor/phpactor ~/.local/share/phpactor
cd ~/.local/share/phpactor
composer install # (composer ^2 & php ^8.1)
```
