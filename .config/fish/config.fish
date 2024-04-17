export EDITOR="nvim"
export VISUAL="nvim"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/bin"

source (starship init fish --print-full-init | psub)
zoxide init fish | source

function compose
	command docker compose $argv
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
