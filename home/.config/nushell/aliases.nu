export alias dotfiles = print 'use `config dotfiles`!'
export alias docker-compose = docker compose
export alias compose = docker compose
export alias buildx = docker buildx
export alias code = codium
export alias xh = ^xh --session=$"($env.XDG_STATE_HOME)/xh_sessions/($env.PWD).session.json"
export alias xhs = ^xhs --session=$"($env.XDG_STATE_HOME)/xh_sessions/($env.PWD).session.json"
export alias "atuin uuid" = uuidgen7 -t

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
    nvim ~/.dotfiles/nixos/
}

export def "config nix-packages" [] {
    nvim ~/.dotfiles/nixos/packages.nix
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

export def "config wezterm" [] {
    nvim ~/.dotfiles/home/.config/wezterm/wezterm.lua
}

export def "config ghostty" [] {
    nvim ~/.dotfiles/home/.config/ghostty/config
}

export def "config ssh" [] {
    nvim ~/.dotfiles/home/.ssh/config
}

export def "config zellij" [] {
    nvim ~/.dotfiles/home/.config/zellij/config.kdl
}

export def "config skhd" [] {
    nvim ~/.dotfiles/home/.config/skhd/skhdrc
    skhd -r
}

export def "venv create" [python_path: string = "" ] {
    echo "(Remember to use uv instead if possible 😀)"
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

export def --env "venv activate" [] {
  if $nu.os-info.name == 'windows' {
    path add ($env.PWD + (char path_sep) + '.venv' + (char path_sep) + 'Scripts')
  } else {
    path add ($env.PWD + (char path_sep) + '.venv' + (char path_sep) + 'bin')
  }
}

export def paste [] {
    cat (do { cb show } | complete | get stderr | str trim --char '"')
}

export def copy [path?: string] {
    if ($in | is-not-empty) {
        $"($in)" | cb copy
    } else if ($path | is-not-empty) {
        cb copy (cat $path)
    }
}


export def "git stash diff" [--stash(-s): int] {
    if $stash == null {
        git stash show -p
    } else {
        git stash show -p $stash
    }
}

export def --wrapped "git checkout" [...args] {
    print "Use `git restore` or `git switch` instead"
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
    let branch = git branch --sort=-committerdate |
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

def ":q" [] { "bruh" }

# Setup proxyman's http proxy by loading the https?_proxy env vars
export def --env "proxyman-cli use" [] {
    ['http'] |
    each {|protocol| [($protocol), ($"($protocol)s")]} |
    flatten |
    each {|protocol|
        let proxy = $"($protocol)_proxy";
        [($proxy) ($proxy | str upcase)]
    } |
    flatten |
    each {|var| [$var 'http://localhost:9090']} |
    into record |
    load-env
}
