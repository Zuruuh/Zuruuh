# the state of the prompt
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
$env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME + '/.local/bin'))
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME + '/.local/share/phpactor/bin'))

if $nu.os-info.name == 'linux' {
    source-env ~/.config/nushell/os/debian/env.nu
} else if $nu.os-info.name == 'macos' {
    source-env ~/.config/nushell/os/darwin/env.nu
}

# Cargo
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME + '/.cargo/bin'))

# Golang
$env.GOPATH = ($env.HOME + '/.local/share/go')
$env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/go/bin')
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.GOPATH + '/bin'))

# PyEnv
$env.PYENV_ROOT = ($env.HOME + '/.pyenv')
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.PYENV_ROOT + '/bin'))
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.PYENV_ROOT + '/versions/' + (pyenv version-name) + '/bin'))
alias pip = python -m pip

# Bun
$env.BUN_INSTALL = ($env.HOME + '/.bun')
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.BUN_INSTALL + '/bin'))

# PHP
$env.COMPOSER_HOME = $env.HOME + '/.local/share/composer'
$env.APP_ENV = dev
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME + '/.local/share/composer/bin'))

# Neovim
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME + '/.local/share/bob/nvim-bin'))

# Node
if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env
    $env.PATH = ($env.PATH | split row (char esep) | prepend [
        $"($env.FNM_MULTISHELL_PATH)/bin"
    ])
}
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME + '/.yarn/bin'))

# Deno
$env.DENO_INSTALL = ($env.HOME + '/.deno')
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.DENO_INSTALL + '/bin'))

# Pulumi
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME + '/.pulumi/bin'))

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

source ~/.config/nushell/plugins_installer.nu
zoxide init nushell | save -f ~/.config/nushell/plugins/zoxide.nu

starship init nu | save -f ~/.config/nushell/plugins/starship.nu
