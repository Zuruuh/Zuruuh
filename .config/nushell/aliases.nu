alias l = ls -la
alias c = clear
alias zshconfig = nvim ~/.zshrc
alias tmuxconfig = nvim ~/.config/tmux/tmux.conf
alias dotfiles = nvim ~/dotfiles
# alias rl = source ~/.zshrc
alias dev = cd ~/dev
alias nvimconfig = nvim ~/.config/nvim
alias docker-compose = docker compose
alias gs = git switch
alias gitconfig = nvim ~/.config/git/config
alias gitignore = nvim ~/.config/git/ignore
alias gph = git push -u origin HEAD
alias gpp = gp
alias gsm = gcm
alias gpl = git pull
alias gsth = git stash
alias git_current_branch = git branch --show-current

def zellijx [] {
    zellij
    exit
}

def mkcd [dir: string] {
    mkdir $dir
    cd $dir
}
