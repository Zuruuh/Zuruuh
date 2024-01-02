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
export alias docker-compose = docker compose
export alias compose = docker compose

export def --env "search history" [--raw: bool = false, query: string] {
    return (history | filter {|cmd| $cmd.command =~ $query} | each {|cmd| if $raw { $cmd } else { $cmd.command } })
}

export def --env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}
