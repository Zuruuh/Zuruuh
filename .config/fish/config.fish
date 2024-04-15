export GOROOT="$HOME/go"
export GOPATH="$HOME/go/packages"
export EDITOR="nvim"
export VISUAL="nvim"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
export PATH="$PATH:$HOME/.local/bin"

source (/home/zuruh/.cargo/bin/starship init fish --print-full-init | psub)
zoxide init fish | source

function compose
	command docker compose $argv
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
