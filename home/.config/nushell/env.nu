source ~/.config/nushell/dotenv.nu
use std *

$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }
$env.ENV_CONVERSIONS = {}

#================================== CONFIG =========================================#

let home = if ('HOME' in $env) { $env.HOME } else { $"C:($env.HOMEPATH)" }

if $nu.os-info.name == 'windows' {
    $env.XDG_DATA_HOME = $env.APPDATA
    $env.XDG_STATE_HOME = $env.LOCALAPPDATA
    $env.PWSH = (which powershell | get path.0)
    path add 'D:\Bin'
}

if $nu.os-info.name == 'linux' and ('/run/current-system/etc/set-environment' | path exists) {
    load-sh-env /run/current-system/etc/set-environment
}

if $nu.os-info.name == 'macos' and ('/run/current-system/etc/bashrc' | path exists) {
    load-sh-env /run/current-system/etc/bashrc
}

if $nu.os-info.name in ['linux', 'macos'] {
    path add --append $"($home)/.local/bin"
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

# Bun
if ($"($home)/.bun" | path exists) {
    $env.BUN_INSTALL = $"($home)/.bun"
    path add $"($env.BUN_INSTALL)/bin"
}

# Python
$env.VIRTUAL_ENV_DISABLE_PROMPT = true

# PHP
$env.COMPOSER_HOME = $"($env.XDG_DATA_HOME)/composer"
$env.APP_ENV = 'dev'

# telemetry and ads
$env.DO_NOT_TRACK = 1
$env.ADBLOCK = 1
$env.STORYBOOK_DISABLE_TELEMETRY = 1
$env.DISABLE_OPENCOLLECTIVE = 1

# random stuff
$env.COLORTERM = 'truecolor'

if not ('EDITOR' in $env) {
    $env.EDITOR = (which nvim | get path.0)
}

$env.VISUAL = $env.EDITOR

if not ('PAGER' in $env) {
    $env.PAGER = (
        if (which tspin | is-empty) {
            (which less | get path.0)
        } else {
            (which tspin | get path.0)
        }
    )
}

$env.AWS_DEFAULT_REGION = 'eu-west-3'
$env.STARSHIP_LOG = 'error'
$env.TERM = 'xterm-256color'

#================================ PLUGINS ========================================#
if ($"($home)/.config/nushell/plugins/nu_scripts" | path exists) {
    rm -rf $"($home)/.config/nushell/plugins/nu_scripts"
}

zoxide init nushell | save -f ~/.config/nushell/plugins/zoxide.nu
starship init nu | save -f ~/.config/nushell/plugins/starship.nu
atuin init nu --disable-up-arrow | save -f ~/.config/nushell/plugins/atuin.nu

$env.CARAPACE_BRIDGES = 'zsh,bash' # optional
$env.CARAPACE_ENV = 0
carapace _carapace nushell | save -f ~/.config/nushell/plugins/carapace.nu
