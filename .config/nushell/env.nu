# Nushell Environment Config Fileenv.
#
# version = "0.84.0"

def create_left_prompt [] {
    mut home = ""
    try {
        if $nu.os-info.name == "windows" {
            $home = $env.USERPROFILE
        } else {
            $home = $env.HOME
        }
    }

    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%Y/%m/%d %r')
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
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

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

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

# Pulumi
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOME + '/.pulumi/bin'))

# random stuff
$env.COLORTERM = 'truecolor'
$env.EDITOR = 'nvim'
$env.PAGER = 'less'
$env.AWS_DEFAULT_REGION = 'eu-west-3'

source ~/.config/nushell/plugins_installer.nu
zoxide init nushell | save -f ~/.config/nushell/plugins/zoxide.nu

starship init nu | save -f ~/.config/nushell/plugins/starship.nu
