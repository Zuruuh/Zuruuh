$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let path_from_string = {|s| $s | split row (char esep) | path expand --no-symlink}
let path_to_string =  {|v| $v | path expand --no-symlink | str join (char esep)}

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: $path_from_string
        to_string: $path_to_string
    }
    "Path": {
        from_string: $path_from_string
        to_string: $path_to_string
    }
}

#=================================================================================#

# Windows compatibility
mut path = if ('PATH' in $env) { $env.PATH } else { $env.Path }
let home = if ('HOME' in $env) { $env.HOME } else { $"C:($env.HOMEPATH)" }

if $nu.os-info.name == 'linux' {
    $path = ($path | prepend '/usr/local/bin')
    $path = ($path | prepend '/usr/bin')
    $path = ($path | prepend ($home + '/.local/bin'))
    $path = ($path | prepend ($home + '/.local/share/phpactor/bin'))
} else if $nu.os-info.name == 'macos' {
    $path = ($path | prepend '/opt/homebrew/bin')
    $path = ($path | prepend '/opt/homebrew/sbin')
} else if ($nu.os-info.name == 'windows') {
    $env.CONTAINERS_REGISTRIES_CONF = $"($home)\\.config\\containers\\registries.conf"
    $path = ($path | prepend 'C:\\Program Files (x86)\\GnuWin32\\bin')
    $path = ($path | prepend 'D:\\Softwares\\php')
    $path = ($path | prepend 'D:\\Softwares\\php-dev')
}

# Cargo
$path = ($path | prepend ($home + '/.cargo/bin'))

# Golang
$env.GOPATH = ($home + '/.local/share/go')
$path = ($path | prepend '/usr/local/go/bin')
$path = ($path | prepend ($env.GOPATH + '/bin'))

# PyEnv
if not (which pyenv | is-empty) {
    $env.PYENV_ROOT = ($home + '/.pyenv')
    $path = ($path | prepend ($env.PYENV_ROOT + '/bin'))
    $path = ($path | prepend ($env.PYENV_ROOT + '/versions/' + (pyenv version-name) + '/bin'))
    alias pip = python -m pip
}

# Bun
$env.BUN_INSTALL = ($home + '/.bun')
$path = ($path | prepend ($env.BUN_INSTALL + '/bin'))

# PHP
$env.COMPOSER_HOME = $home + '/.local/share/composer'
$env.APP_ENV = dev
$path = ($path | prepend ($home + '/.local/share/composer/bin'))

# Neovim
$path = ($path | prepend ($home + '/.local/share/bob/nvim-bin'))

# Node
if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env
    $path = ($path | prepend [
        $"($env.FNM_MULTISHELL_PATH)/bin"
        $"($env.FNM_MULTISHELL_PATH)/"
    ])
}
$path = ($path | prepend ($home + '/.yarn/bin'))

# Deno
$env.DENO_INSTALL = ($home + '/.deno')
$path = ($path | prepend ($env.DENO_INSTALL + '/bin'))

# Pulumi
$path = ($path | prepend ($home + '/.pulumi/bin'))

# telemetry and ads
$env.DO_NOT_TRACK = 1
$env.ADBLOCK = 1
$env.STORYBOOK_DISABLE_TELEMETRY = 1
$env.DISABLE_OPENCOLLECTIVE = 1

if 'PATH' in $env {
    $env.PATH = $path
} else {
    $env.Path = $path
}

# random stuff
$env.COLORTERM = 'truecolor'
$env.EDITOR = (which nvim | get path.0)
$env.PAGER = 'less'
$env.AWS_DEFAULT_REGION = 'eu-west-3'
$env.STARSHIP_LOG = 'error'
$env.TERM = 'xterm-256color'

source ~/.config/nushell/plugins_installer.nu
zoxide init nushell | save -f ~/.config/nushell/plugins/zoxide.nu

starship init nu | save -f ~/.config/nushell/plugins/starship.nu
