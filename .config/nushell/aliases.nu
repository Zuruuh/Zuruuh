export alias dotfiles = nvim ~/dotfiles
export alias gs = git switch
export alias gitconfig = nvim ~/.config/git/config
export alias gitignore = nvim ~/.config/git/ignore
export alias gph = git push -u origin HEAD
export alias gpp = gp
export alias gsm = gcm
export alias gpl = git pull
export alias gsth = git stash
export alias git_current_branch = git branch --show-current
export alias docker = podman
export alias docker-compose = podman compose
export alias compose = podman compose
export alias code = codium

export def bc [...command] {
    bin/console ...$command
}

export def --env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

export def --env dev [] {
    let dir = (
        ls ~/dev
        | where type == 'dir'
        | each {get name | path basename}
        | shuffle
        | str join (char newline)
        | sk
    )

    cd $"~/dev/($dir)"
}
