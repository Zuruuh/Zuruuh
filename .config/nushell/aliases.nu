export alias dotfiles = echo 'use `config dotfiles`!'
export alias gs = git switch
export alias gph = git push -u origin HEAD
export alias gpp = gp
export alias gsm = gcm
export alias gpl = git pull
export alias gsth = git stash
export alias git_current_branch = git branch --show-current
export alias docker-compose = docker compose
export alias compose = docker compose
export alias code = codium

export def nix-shell [
    ...args
] {
    ^nix-shell --command nu -p ...$args
}

export def "config dotfiles" [] {
    nvim ~/.dotfiles/
}

export def "config nix" [] {
    nvim ~/dotfiles/etc/nixos/
}

export def "config nvim" [] {
    nvim ~/.dotfiles/.config/nvim/
}

export def "config nushell" [] {
    nvim ~/.dotfiles/.config/nushell/
}

export def --env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

export def --env dev [] {
    let dev = if $nu.os-info.name == 'windows' { 'D:\\dev' } else { '~/dev' }
    let dev = ($dev | path expand)

    let dir = (
        ls $dev
        | where type == 'dir'
        | each {get name | path basename}
        | shuffle
        | str join (char newline)
        | fzf
    )

    cd $"($dev)(char path_sep)($dir)"
}

export def switch [] {
    let branch = git branch |
        str trim |
        split row (char newline) |
        filter {|branch| $branch !~ '^\* '} |
        each {str trim} |
        prepend '-' |
        str join (char newline) |
        fzf --height '50%'

    if ($branch | is-not-empty) {
        git switch $branch
    }
}
