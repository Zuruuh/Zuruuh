export alias dotfiles = print 'use `config dotfiles`!'
export alias docker-compose = docker compose
export alias compose = docker compose
export alias buildx = docker buildx
export alias code = codium
export alias "atuin uuid" = random uuid --version 7
export alias cat = bat
export alias base64 = print 'use `encode base64`!'
export alias keys = print 'use `columns`!'
export alias pairs = print 'use `items {callback}` OR `transpose key value`!'
export alias ':q' = print 'bouffon va'

export def nix-shell --wrapped [...args] {
    $"Use (ansi purple)nix shell nixpkgs#($args | get 0 --optional | default '...')(ansi reset) instead!"
}

export def --wrapped nix-collect-garbage [...args] {
    $"Use (ansi purple)nix store gc -v(ansi reset) instead!"
}

export def "wsl ip" [] {
    ip route show | rg -i default  | split column ' ' | get 0.column3
}

export def "wsl open" [path: string] {
    /mnt/c/Windows/explorer.exe ("\\\\wsl.localhost\\NixOS" + ((pwd) | path join $path | str replace -a '/' '\'))
}
export alias config = nvim ~/.dotfiles
export alias "config dotfiles" = nvim ~/.dotfiles/
export alias "config nix" = nvim ~/.dotfiles/nix/
export alias "config nix packages" = nvim ~/.dotfiles/nix/packages.nix
export alias "config nvim" = nvim ~/.dotfiles/home/.config/nvim/init.lua
export alias "config nu" = nvim ~/.dotfiles/home/.config/nushell/
export alias "config aliases" = nvim ~/.dotfiles/home/.config/nushell/aliases.nu
export alias "config starship" = nvim ~/.dotfiles/home/.config/starship.toml
export alias "config wezterm" = nvim ~/.dotfiles/home/.config/wezterm/wezterm.lua
export alias "config ghostty" = nvim ~/.dotfiles/home/.config/ghostty/config
export alias "config ssh" = nvim ~/.dotfiles/home/.ssh/config
export alias "config zellij" = nvim ~/.dotfiles/home/.config/zellij/config.kdl
export alias "config git" = nvim ~/.dotfiles/home/.config/git/
export alias "config jujutsu" = nvim ~/.dotfiles/home/.config/jj/

export def "clipboard paste" [] {
    cat (do { cb show } | complete | get stderr | str trim --char '"')
}

export def "clipboard copy" [path?: string] {
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
        | get name
        | path basename
        | shuffle
        | str join (char newline)
        | fzf
    )

    cd $"($dev)(char path_sep)($dir)"
}

export alias "git switch -i" = git switch --interactive
export def "git switch --interactive" [] {
    let branch = git branch --sort=-committerdate |
        str trim |
        split row (char newline) |
        where {|branch| $branch !~ '^\* '} |
        each {str trim} |
        prepend '-' |
        str join (char newline) |
        fzf --height '50%'

    if ($branch | is-not-empty) {
        git switch $branch
    }
}

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

export def "jj merge" [branch: string] {
    print $"Use `jj new @- ($branch)` instead!"
}
