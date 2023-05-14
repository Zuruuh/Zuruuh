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

source "$HOME/.zshenv"
source "$ZSH/oh-my-zsh.sh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "/home/zuruh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Go
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

alias ls='exa -lah --git --icons'
alias l='ls'
alias find='fd'
alias ack='ambr'
alias grep='rg'
alias cat='bat'

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
alias vimconfig='vim ~/.config/nvim/init.lua'
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
alias open='gio open'
alias msw='bin/console messenger:stop-workers'
alias ddd='bin/console d:d:d --force'
alias ddc='bin/console d:d:c'
alias dmm='bin/console d:m:m'


# fnm
export PATH="/home/zuruh/.local/share/fnm:$PATH"
eval "`fnm env --use-on-cd`"
