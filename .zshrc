export ZSH="/home/zuruh/.oh-my-zsh"

ZSH_THEME="intheloop"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Themes
# eastwood
# robbyrussell
# miloshadzic
# intheloop
# simple
# wezm
# fletcherm
# gallois

plugins=(
    z
    git
    calc
    bundler
    history
    copypath
    dirhistory
    auto-notify
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

alias c='clear'
alias zshconfig='vim ~/.zshrc'
alias rl='source ~/.zshrc'
alias audio='rm -rf ~/.config/pulse;pulseaudio -k;pulseaudio -D;reboot'
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias tf='terraform'
alias vcc='rm -rf ./var/cache'
alias dev='cd ~/dev'
alias vimconfig='vim ~/.SpaceVim.d/init.toml'
alias john="~/dev/john-the-ripper/run/john"
alias hf='history | fzf'

# opam configuration
test -r /home/zuruh/.opam/opam-init/init.zsh && . /home/zuruh/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
export PATH=$PATH:/home/zuruh/.spicetify

# NVM Config
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NODE_PATH="$(npm config get prefix)/lib/node_modules"

# NVM version loader on directory change
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


