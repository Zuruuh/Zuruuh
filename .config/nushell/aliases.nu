export alias l = ls -la
export alias c = clear
export alias zshconfig = nvim ~/.zshrc
export alias tmuxconfig = nvim ~/.config/tmux/tmux.conf
export alias dotfiles = nvim ~/dotfiles
export alias dev = cd ~/dev
export alias nvimconfig = nvim ~/.config/nvim
export alias docker-compose = docker compose
export alias gs = git switch
export alias gitconfig = nvim ~/.config/git/config
export alias gitignore = nvim ~/.config/git/ignore
export alias gph = git push -u origin HEAD
export alias gpp = gp
export alias gsm = gcm
export alias gpl = git pull
export alias gsth = git stash
export alias git_current_branch = git branch --show-current

export def-env rl [] {
    $"source '($nu.config-path)'"
}

export def-env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}
