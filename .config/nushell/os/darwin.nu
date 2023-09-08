$env.PATH = ($env.PATH | split row (char esep) | prepend '/opt/homebrew/bin')

$env.SDKROOT = '/Applications/Xcode-beta.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk'
$env.MACOSX_DEPLOYMENT_TARGET = '13.4'
$env.PYTHON_CONFIGURE_OPTS = '--enable-framework'

## Custom aliases

$env.STAFFMATCH_CORE = $env.HOME + '/dev/staffmatch-core'
$env.STAFFMATCH_CORE_CONSOLE = $env.STAFFMATCH_CORE + '/bin/console'

alias gsd = git switch development
def watcher [] {
    cd ~/dev/staffmatch-watcher
    activemq purge
    npm run start
}
def dev [] {
    cd $env.STAFFMATCH_CORE
    clear
}
alias nginxconfig = nvim /opt/homebrew/etc/nginx/sites-enabled/staffmatch-core.conf
alias bc = php $env.STAFFMATCH_CORE_CONSOLE
alias bcd = bc --env=dev
alias bct = bc --env=test
alias bb = php $env.STAFFMATCH_CORE/bin/behat

def bbf [] {
    echo bb (fd . features/Staffmatch --type file | fzf)| pbcopy
    bb (fd . features/Staffmatch --type file | fzf)
}

alias dsu = bcd d:s:u --force --dump-sql
alias dst = bct d:s:u --force
alias dst = bct d:s:u --force
alias assets = bcd assets:install --symlink --relative
def rt [] {
    rm -f /tmp/staffmatch_test.sql
    rm -f /tmp/idsArray.csv
}
def brewrs [...args: string] {
    brew services restart ($args | str join ' ')
}
alias gsm = gcm
alias services = brew services
def rdb [] {
    bcd d:d:d --force --if-exists
    bcd d:d:c
    loab
    dsu
}
def rtdb [] {
    rt
    bct d:d:d --force --if-exists
    bct d:d:c
    dst
}

def perso [] {
    cd ~/dev/perso
    clear
}

alias es = bcd staffmatch:es:update
def phpunit [...args: string] {
    ./bin/phpunit ($args | str join ' ') -vvv
}
def phpconfig [] {
    nvim ((php-config --ini-path) + '/php.ini')
}
alias notes = nvim $env.HOME + '/Documents/notes'
def logs [] {
    tail -f var/logs/dev.log | grep app\.
}

# db dumping stuff
def dump [dump?: string] {
    mysqldump staffmatch -u root -pPASSWORD > $env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.sql'
}
def load [dump?: string] {
    mysql -u root staffmatch -pPASSWORD < $env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.test.sql'
}

# db dumping stuff
def dump-test [dump?: string] {
    mysqldump staffmatch -u root -pPASSWORD > $env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.sql'
}
def load-test [dump?: string] {
    mysql -u root staffmatch -pPASSWORD < $env.STAFFMATCH_CORE + '/.ignored/dumps/' + $dump + '.test.sql'
}

alias dumptest = dump-test
alias loadtest = load-test

def phpcs [] {
    make EXEC_PHP='' phpcbf
    git add .
    git commit -m fix cs
    git push
}

def usephp [version: float] {
    if (which php | is-empty) {
        brew link php@$version
    } else {
        let current_php_version = (php -r echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;)
        brew unlink php@$current_php_version
        brew link --overwrite --force php@$version
    }
}

def admin [] {
    cd ~/dev/staffmatch-admin
    git pull
    echo n | npm run start
}

def front [] {
    cd ~/dev/staffmatch-front/app
    git pull
    npm run start #&> ~/dev/staffmatch-front/front.log
}

alias oc = cd ~/oc
def sm-services [] {
    echo ["php@7.4", "mysql@5.7", "activemq", "redis", "nginx"]
}

def sm-services-start [] {
    sm-services | each {|service| services start $service }
}
def sm-services-stop [] {
    sm-services | each {|service| services stop $service }
}

alias ddd = bcd d:d:d --force --if-exists
alias dddt = bct d:d:d --force --if-exists
alias ddc = bcd d:d:c --if-not-exists
alias ddct = bct d:d:c --if-not-exists
alias brwe = brew
alias berw = brew
alias brwe = brew
