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

export def --env mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

export alias bc = php ($env.STAFFMATCH_CORE_CONSOLE)
export alias bcd = bc --env=dev
export alias bct = bc --env=test
export alias bb = php ($env.STAFFMATCH_CORE + '/bin/behat')

export def bbf [--verbose (-v): bool = true] {
    let test_file = (fd . features/Staffmatch --type file | fzf)
    let verbosity = if $verbose == true { '-vvv ' } else { '' }

    echo ('bb ' + $verbosity + $test_file) | pbcopy
    bb ($verbosity) ($test_file)
}

export alias dsu = bcd d:s:u --force --dump-sql
export alias dst = bct d:s:u --force
export alias dst = bct d:s:u --force
export def rt [] {
    rm -f /tmp/staffmatch_test.sql
    rm -f /tmp/idsArray.csv
}
export def rdb [] {
    bcd d:d:d --force --if-exists
    bcd d:d:c
    loab
    dsu
}
export def rtdb [] {
    rt
    bct d:d:d --force --if-exists
    bct d:d:c
    dst
}

alias _mysql = mysql --user root --database staffmatch --host localhost --port 3306 --protocol tcp
alias _mysqldump = mysqldump --user root --database staffmatch --host localhost --port 3306 --protocol tcp

# db dumping stuff
export def dump [dump?: string = ''] {
    _mysqldump staffmatch | save -f ($env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.sql')
}
export def load [dump?: string = ''] {
    cat ($env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.sql') | _mysql
}

# db dumping stuff
export def dump-test [dump?: string = ''] {
    _mysqldump staffmatch | save -f ($env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.tset.sql')
}
export def load-test [dump?: string = ''] {
    cat ($env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.test.sql') | _mysql
}

export alias dumptest = dump-test
export alias loadtest = load-test

export alias ddd = bcd d:d:d --force --if-exists
export alias dddt = bct d:d:d --force --if-exists
export alias ddc = bcd d:d:c --if-not-exists
export alias ddct = bct d:d:c --if-not-exists
