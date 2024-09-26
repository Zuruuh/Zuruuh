source ~/.config/nushell/dotenv.nu

$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

let path_from_string = {|s| $s | split row (char esep) | path expand --no-symlink}
let path_to_string =  {|v| $v | path expand --no-symlink | str join (char esep)}

$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: $path_from_string
        to_string: $path_to_string
    }
}

#================================== CONFIG =========================================#

use std *

let home = if ('HOME' in $env) { $env.HOME } else { $"C:($env.HOMEPATH)" }

if $nu.os-info.name == 'windows' {
    # $env.XDG_CONFIG_HOME = $"($home)/.config"
    $env.XDG_DATA_HOME = $env.APPDATA
    $env.XDG_STATE_HOME = $env.LOCALAPPDATA
}

if $nu.os-info.name == 'linux' and ('/etc/set-environment' | path exists) {
    load-sh-env /etc/set-environment
}

if $nu.os-info.name in ['linux', 'macos'] {
    path add $"($home)/.local/bin"
    path add $"($env.XDG_DATA_HOME)/phpactor/bin"
}

if $nu.os-info.name == 'macos' {
    path add '/opt/homebrew/bin'
    path add '/opt/homebrew/sbin'
    path add $"($home)/.orbstack/bin"
}

if ($nu.os-info.name == 'windows') {
    $env.CONTAINERS_REGISTRIES_CONF = $"($home)\\.config\\containers\\registries.conf"

    # android
    $env.ANDROID_HOME = 'D:\\Android'
    $env.NDK_HOME = (ls $"($env.ANDROID_HOME)\\ndk" | get 0.name)
    path add 'D:\\Android\\platform-tools'
}

# Cargo
path add $"($home)/.cargo/bin"

# nushell
$env.SHELL = (which nu | get path.0)

# PyEnv
if ($"($home)/.pyenv" | path exists) {
    $env.PYENV_ROOT = $"($home)/.pyenv"
    path add $"($env.PYENV_ROOT)/bin"
    path add $"($env.PYENV_ROOT)/versions/(pyenv version-name)/bin"
    # alias pip = python -m pip
}

# Bun
if ($"($home)/.bun" | path exists) {
    $env.BUN_INSTALL = $"($home)/.bun"
    path add $"($env.BUN_INSTALL)/bin"
}

# PHP
$env.COMPOSER_HOME = $"($env.XDG_DATA_HOME)/composer"
$env.APP_ENV = 'dev'
path add $"($env.XDG_DATA_HOME)/composer/bin"
path add $"($env.XDG_DATA_HOME)/composer/vendor/bin"

# Node
if (which fnm | is-not-empty) {
    ^fnm env --json | from json | load-env
    path add $"($env.FNM_MULTISHELL_PATH)/bin"
    path add $"($env.FNM_MULTISHELL_PATH)/"
}

if ($"($home)/.yarn/bin" | path exists) {
    path add $"($home)/.yarn/bin"
}

if ($"($home)/.deno" | path exists) {
    $env.DENO_INSTALL = $"($home)/.deno"
    path add $"($env.DENO_INSTALL)/bin"
}

# Pulumi
if ($"($home)/.pulumi" | path exists) {
    path add $"($home)/.pulumi/bin"
}

# telemetry and ads
$env.DO_NOT_TRACK = 1
$env.ADBLOCK = 1
$env.STORYBOOK_DISABLE_TELEMETRY = 1
$env.DISABLE_OPENCOLLECTIVE = 1

# random stuff
$env.COLORTERM = 'truecolor'
$env.EDITOR = (which nvim | get path.0)
$env.PAGER = (
    if (which tspin | is-empty) {
        (which less | get path.0)
    } else {
        (which tspin | get path.0)
    }
)
$env.AWS_DEFAULT_REGION = 'eu-west-3'
$env.STARSHIP_LOG = 'error'
$env.TERM = 'xterm-256color'

#================================ PLUGINS ========================================#
if not ($"($home)/.config/nushell/plugins/nu_scripts" | path exists) {
    git clone 'https://github.com/nushell/nu_scripts' ~/.config/nushell/plugins/nu_scripts
}

zoxide init nushell | save -f ~/.config/nushell/plugins/zoxide.nu
starship init nu | save -f ~/.config/nushell/plugins/starship.nu
