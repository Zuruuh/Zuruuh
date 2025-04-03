source ~/.config/nushell/dotenv.nu
use std *

$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }
$env.ENV_CONVERSIONS = {}

let home = if ('HOME' in $env) { $env.HOME } else { $"C:($env.HOMEPATH)" }

if $nu.os-info.name == 'windows' {
    $env.XDG_DATA_HOME = $env.APPDATA
    $env.XDG_STATE_HOME = $env.LOCALAPPDATA
    $env.PWSH = (which pwsh | get path.0)
    path add 'D:\Bin'
    # android
    $env.ANDROID_HOME = 'D:\\Android'
    $env.NDK_HOME = (ls $"($env.ANDROID_HOME)\\ndk" | get 0.name)
    path add 'D:\\Android\\platform-tools'
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
    let tspin = which tspin;
    $env.PAGER = (
        if ($tspin | is-empty) {
            (which less | get path.0)
        } else {
            ($tspin | get path.0)
        }
    )
}

$env.AWS_DEFAULT_REGION = 'eu-west-3'
$env.STARSHIP_LOG = 'error'
$env.TERM = 'xterm-256color'

#================================ PLUGINS ========================================#
if $nu.os-info.name != 'windows' {
    # These operations are painfully slow on windows (+250ms)
    # So it's better if it's done manually and periodically
    let now = date now | format date '%Y-%m-%d';
    let should_refresh_plugins = try {
        let plugins_refreshed_at = open -r ~/.config/nushell/plugins/plugins_refreshed_at.txt
        $plugins_refreshed_at != $now
    } catch { true }

    if $should_refresh_plugins {
        let _ = [
            { || $now | save -f ~/.config/nushell/plugins/plugins_refreshed_at.txt }
            { || zoxide init nushell | save -f ~/.config/nushell/plugins/zoxide.nu }
            { || starship init nu | save -f ~/.config/nushell/plugins/starship.nu }
            { || atuin init nu --disable-up-arrow | save -f ~/.config/nushell/plugins/atuin.nu }
        ] | par-each {|callback| do $callback}
    }
}
