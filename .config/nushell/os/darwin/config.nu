export alias gsd = git switch development
export def watcher [] {
    cd ~/dev/staffmatch-watcher
    activemq purge
    npm run start
}
export alias dev = cd $env.STAFFMATCH_CORE
export alias nginxconfig = nvim /opt/homebrew/etc/nginx/sites-enabled/staffmatch-core.conf
export alias bc = php $env.STAFFMATCH_CORE_CONSOLE
export alias bcd = bc --env=dev
export alias bct = bc --env=test
export alias bb = php $env.STAFFMATCH_CORE/bin/behat

export def bbf [] {
    echo bb (fd . features/Staffmatch --type file | fzf)| pbcopy
    bb (fd . features/Staffmatch --type file | fzf)
}

export alias dsu = bcd d:s:u --force --dump-sql
export alias dst = bct d:s:u --force
export alias dst = bct d:s:u --force
export alias assets = bcd assets:install --symlink --relative
export def rt [] {
    rm -f /tmp/staffmatch_test.sql
    rm -f /tmp/idsArray.csv
}
export def brewrs [...args: string] {
    brew services restart ($args | str join ' ')
}
export alias gsm = gcm
export alias services = brew services
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

export def perso [] {
    cd ~/dev/perso
    clear
}

export alias es = bcd staffmatch:es:update
export def phpunit [...args: string] {
    ./bin/phpunit ($args | str join ' ') -vvv
}
export def phpconfig [] {
    nvim ((php-config --ini-path) + '/php.ini')
}
export alias notes = nvim $env.HOME + '/Documents/notes'
export def logs [] {
    tail -f var/logs/dev.log | grep app\.
}

# db dumping stuff
export def dump [dump?: string] {
    mysqldump staffmatch -u root -pPASSWORD | save ($env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.sql')
}
export def load [dump?: string = ''] {
    cat ($env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.test.sql') | mysql -u root staffmatch -pPASSWORD
}

# db dumping stuff
export def dump-test [dump?: string] {
    mysqldump staffmatch -u root -pPASSWORD | save ($env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.sql')
}
export def load-test [dump?: string] {
    cat ($env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.test.sql') | mysql -u root staffmatch -pPASSWORD
}

export alias dumptest = dump-test
export alias loadtest = load-test

export def phpcs [] {
    make EXEC_PHP='' phpcbf
    git add .
    git commit -m fix cs
    git push
}

export def usephp [version: float] {
    if (which php | is-empty) {
        brew link ('php@' + ($version | to text))
    } else {
        let current_php_version = (php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;")
        brew unlink ('php@' + ($current_php_version | to text))
        brew link --overwrite --force ('php@' + ($version | to text))
    }
}

export def admin [] {
    cd ~/dev/staffmatch-admin
    git pull
    echo n | npm run start
}

export def front [] {
    cd ~/dev/staffmatch-front/app
    git pull
    npm run start #&> ~/dev/staffmatch-front/front.log
}

export alias oc = cd ~/oc
export def sm-services [] {
    echo ["php@7.4", "mysql@5.7", "activemq", "redis", "nginx"]
}

export def sm-services-start [] {
    sm-services | each {|service| services start $service }
}
export def sm-services-stop [] {
    sm-services | each {|service| services stop $service }
}

export alias ddd = bcd d:d:d --force --if-exists
export alias dddt = bct d:d:d --force --if-exists
export alias ddc = bcd d:d:c --if-not-exists
export alias ddct = bct d:d:c --if-not-exists
export alias brwe = brew
export alias berw = brew
export alias brwe = brew
