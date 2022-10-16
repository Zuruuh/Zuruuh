#!/bin/zsh
# Load RUST components
source "$HOME/.cargo/env"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="random"

# Themes
ZSH_THEME_RANDOM_CANDIDATES=("eastwood" "robbyrussell" "miloshadzic" "intheloop" "simple" "wezm" "fletcherm" "gallois")

plugins=(
    z
    git
    docker
    bundler
    history
    copypath
    dirhistory
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
)

zstyle ':omz:update' mode auto      # update automatically without asking

zstyle ':omz:update' frequency 7

# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# HIST_STAMPS="mm/dd/yyyy"

export COLORTERM=truecolor

alias phpversionmanager='pvmp'
alias phpvm='pvm'
alias pvm='sudo update-alternatives --config php'

alias c='clear'
alias zshconfig='vim ~/.zshrc'
alias rl='source ~/.zshrc'
alias audio='rm -rf ~/.config/pulse;pulseaudio -k;pulseaudio -D;reboot'
alias sail='[ -f sail ] && bash sail || bash vendor/bin/sail'
alias tf='terraform'
alias vcc='rm -rf ./var/cache'
alias dev='cd ~/dev'
alias vim='nvim'
alias svim='sudo nvim'
alias vimconfig='vim ~/.config/nvim/init.vim'
alias hf='history | fzf'
alias python='python3'
alias docker-compose='docker compose'
alias gs='git switch'
alias gitconfig='vim ~/.gitconfig'
alias gitignore='vim ~/.gitignore'
alias gph='git push -u origin HEAD'
alias gsm='gcm'
alias gsd='git switch dev'
alias gpl='git pull'
alias composer-bin='export PATH="$PATH:$PWD/vendor/bin"'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

source "$HOME/.zshenv"
source "$ZSH/oh-my-zsh.sh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "/home/zuruh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# WSL
# export PATH="/mnt/d/Softwares/Microsoft VS Code/bin:$PATH"

