export alias dotfiles = echo 'use `config dotfiles`!'
export alias git_current_branch = git branch --show-current
export alias docker-compose = docker compose
export alias compose = docker compose
export alias buildx = docker buildx
export alias code = codium
export alias nxd = nix develop --command $env.SHELL

export def nix-shell [
    ...args
] {
    ^nix-shell --command nu -p ...$args
}

export def "wsl ip" [] {
    ip route show | rg -i default  | split column ' ' | get 0.column3
}

export def "wsl open" [path: string] {
    /mnt/c/Windows/explorer.exe ("\\\\wsl.localhost\\NixOS" + ((pwd) | path join $path | str replace -a '/' '\'))
}

export def config [] {
    config dotfiles
}

export def "config dotfiles" [] {
    nvim ~/.dotfiles/
}

export def "config nix" [] {
    nvim ~/dotfiles/root/etc/nixos/
}

export def "config nix-packages" [] {
    nvim ~/dotfiles/root/etc/nixos/packages.nix
}

export def "config nvim" [] {
    nvim ~/.dotfiles/home/.config/nvim/init.lua
}

export def "config nu" [] {
    nvim ~/.dotfiles/home/.config/nushell/
}

export def "config aliases" [] {
    nvim ~/.dotfiles/home/.config/nushell/aliases.nu
}

export def "config starship" [] {
    nvim ~/.dotfiles/home/.config/starship.toml
}

export def "config alacritty" [] {
    nvim ~/.dotfiles/home/.config/alacritty/
}

export def "config ssh" [] {
    nvim ~/.dotfiles/home/.ssh/config
}

export def "config zellij" [] {
    nvim ~/.dotfiles/home/.config/zellij/config.kdl
}

export def "venv create" [python_path: string = "" ] {
    if ('.venv' | path exists) {
        return (
            error make {
                msg: 'Virtual environment already exists in this directory.'
            }
        )
    }

    let python = if ($python_path | str length) == 0 {
        which python | get 0.path
    } else {
        $python_path
    }

    do { ^$python '-m' 'venv' $"(pwd)/.venv" } | complete

    return
}

export def paste [] {
    cat (do { cb show } | complete | get stderr | str trim --char '"')
}

export def copy [] {
    cb copy $in
}

export def --env "venv activate" [] {
  if $nu.os-info.name == 'windows' {
    path add ($env.PWD + (char path_sep) + '.venv' + (char path_sep) + 'Scripts')
  } else {
    path add ($env.PWD + (char path_sep) + '.venv' + (char path_sep) + 'bin')
  }
}

export def "git stash diff" [] {
    git stash show -p
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

export def l [...args] {
    eza --long --all --icons --git ...$args
}

export def leetcode [] {
    nvim leetcode.nvim
}
