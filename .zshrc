# Created by Zap installer
[[ $TERM != "screen" ]] && exec tmux

# ZAP Config
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "hlissner/zsh-autopair"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "agkozak/zsh-z"
plug "zsh-users/zsh-history-substring-search"
plug "Aloxaf/fzf-tab"

# Load and initialise completion system
autoload -Uz compinit
compinit

# Rust/Cargo
source "$HOME/.cargo/env"

# Golang
export PATH="$PATH:$HOME/softwares/go/bin"

# Nodejs (fnm)
export PATH="/home/zuruh/.local/share/fnm:$PATH"
eval "`fnm env`"

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(pyenv virtualenv-init -)"

# bun
[ -s "/home/zuruh/.bun/_bun" ] && source "/home/zuruh/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Youki
export PATH="$PATH:$HOME/softwares/youki"

#####################
#####################
#####################
#####################
#####################

## Custom config

export COLORTERM=truecolor
export EDITOR=nvim

## Custom aliases

alias ls='exa -lah --git --icons'
alias l='ls'
alias find='fd'
alias ack='ambr'
alias grep='rg'
alias cat='batcat'

alias phpversionmanager='pvmp'
alias phpvm='pvm'
alias pvm='sudo update-alternatives --config php'

alias c='clear'
alias zshconfig='vim ~/.zshrc'
alias wslconfig='sudo vim /etc/wsl.conf'
alias rl='source ~/.zshrc'
# alias audio='rm -rf ~/.config/pulse;pulseaudio -k;pulseaudio -D;reboot'
alias tf='terraform'
alias vcc='rm -rf ./var/cache'
alias dev='cd ~/dev'
alias vim='nvim'
alias vimconfig='vim ~/.config/nvim'
alias hf='cat -p --no-pager ~/.zsh_history | fzf'
alias python='python3'
alias docker-compose='docker compose'
alias gs='git switch'
alias gitconfig='vim ~/.gitconfig'
alias gitignore='vim ~/.gitignore'
alias gph='git push -u origin HEAD'
alias gsm='gcm'
alias gsd='git switch dev'
alias gpl='git pull'
alias open='explorer.exe'
