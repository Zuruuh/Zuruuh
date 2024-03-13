# the state of the prompt
mut path = if ('PATH' in $env) { $env.PATH } else { $env.Path }
let home = if ('HOME' in $env) { $env.HOME } else { $env.HOMEPATH }

$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

#=================================================================================#

# Shared
$path = ($path | split row (char esep) | prepend '/usr/local/bin')
$path = ($path | split row (char esep) | prepend '/usr/bin')
$path = ($path | split row (char esep) | prepend ($home + '/.local/bin'))
$path = ($path | split row (char esep) | prepend ($home + '/.local/share/phpactor/bin'))

if $nu.os-info.name == 'linux' {
    source-env ~/.config/nushell/os/debian.nu
} else if $nu.os-info.name == 'macos' {
    source-env ~/.config/nushell/os/darwin.nu
}

# Cargo
$path = ($path | split row (char esep) | prepend ($home + '/.cargo/bin'))

# Golang
$env.GOPATH = ($home + '/.local/share/go')
$path = ($path | split row (char esep) | prepend '/usr/local/go/bin')
$path = ($path | split row (char esep) | prepend ($env.GOPATH + '/bin'))

# PyEnv
if ((which pyenv | length) > 0) {
    $env.PYENV_ROOT = ($home + '/.pyenv')
    $path = ($path | split row (char esep) | prepend ($env.PYENV_ROOT + '/bin'))
    $path = ($path | split row (char esep) | prepend ($env.PYENV_ROOT + '/versions/' + (pyenv version-name) + '/bin'))
    alias pip = python -m pip
}

# Bun
$env.BUN_INSTALL = ($home + '/.bun')
$path = ($path | split row (char esep) | prepend ($env.BUN_INSTALL + '/bin'))

# PHP
$env.COMPOSER_HOME = $home + '/.local/share/composer'
$env.APP_ENV = dev
$path = ($path | split row (char esep) | prepend ($home + '/.local/share/composer/bin'))

# Neovim
$path = ($path | split row (char esep) | prepend ($home + '/.local/share/bob/nvim-bin'))

# Node
if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env
    $path = ($path | split row (char esep) | prepend [
        $"($env.FNM_MULTISHELL_PATH)/bin"
        $"($env.FNM_MULTISHELL_PATH)/"
    ])
}
$path = ($path | split row (char esep) | prepend ($home + '/.yarn/bin'))

# Deno
$env.DENO_INSTALL = ($home + '/.deno')
$path = ($path | split row (char esep) | prepend ($env.DENO_INSTALL + '/bin'))

# Pulumi
$path = ($path | split row (char esep) | prepend ($home + '/.pulumi/bin'))

# random stuff
$env.COLORTERM = 'truecolor'
$env.EDITOR = (which nvim | get path.0)
$env.PAGER = 'less'
$env.AWS_DEFAULT_REGION = 'eu-west-3'
$env.STARSHIP_LOG = 'error'
$env.TERM = 'xterm-256color'

# telemetry and ads
$env.DO_NOT_TRACK = 1
$env.ADBLOCK = 1
$env.STORYBOOK_DISABLE_TELEMETRY = 1
$env.DISABLE_OPENCOLLECTIVE = 1

if ($nu.os-info.name == 'windows') {
    $env.CONTAINERS_REGISTRIES_CONF = $"C:($home)\\.config\\containers\\registries.conf"
    $path = ($path | split row (char esep) | prepend 'C:\\Program Files (x86)\\GnuWin32\\bin')
    $path = ($path | split row (char esep) | prepend 'D:\\Softwares\\php')
    $path = ($path | split row (char esep) | prepend 'D:\\Softwares\\php-dev')
}

if ('PATH' in $env) {
    $env.PATH = $path
} else {
    $env.Path = $path
}

source ~/.config/nushell/plugins_installer.nu
zoxide init nushell | save -f ~/.config/nushell/plugins/zoxide.nu

starship init nu | save -f ~/.config/nushell/plugins/starship.nu
