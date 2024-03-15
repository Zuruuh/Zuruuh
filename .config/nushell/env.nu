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
let home = if ('HOME' in $env) { $env.HOME } else { $"C:($env.HOMEPATH)" }
def --env add_path [dir: string] {
    if ('PATH' in $env) {
        $env.PATH = ($env.PATH | prepend $dir)
    } else {
        $env.Path = ($env.Path | prepend $dir)
    }
    
}

if $nu.os-info.name == 'linux' {
    add_path '/usr/local/bin'
    add_path '/usr/bin'
    add_path ($home + '/.local/bin')
    add_path ($home + '/.local/share/phpactor/bin')
} else if $nu.os-info.name == 'macos' {
    add_path '/opt/homebrew/bin'
    add_path '/opt/homebrew/sbin'
    add_path $"($home)/.orbstack/bin"
} else if ($nu.os-info.name == 'windows') {
    $env.CONTAINERS_REGISTRIES_CONF = $"($home)\\.config\\containers\\registries.conf"
    add_path 'C:\\Program Files (x86)\\GnuWin32\\bin'
    add_path 'D:\\Softwares\\php'
    add_path 'D:\\Softwares\\php-dev'
    add_path 'D:\\Softwares\\GnuWin32\\bin'
    add_path 'D:\\bin'
}

# Cargo
add_path ($home + '/.cargo/bin')

# Golang
$env.GOPATH = ($home + '/.local/share/go')
add_path '/usr/local/go/bin'
add_path ($env.GOPATH + '/bin')

# PyEnv
if ($"($home)/.pyenv" | path exists) {
    $env.PYENV_ROOT = ($home + '/.pyenv')
    add_path ($env.PYENV_ROOT + '/bin')
    add_path ($env.PYENV_ROOT + '/versions/' + (pyenv version-name) + '/bin')
    alias pip = python -m pip
}

# Bun
$env.BUN_INSTALL = ($home + '/.bun')
add_path ($env.BUN_INSTALL + '/bin')

# PHP
$env.COMPOSER_HOME = $home + '/.local/share/composer'
$env.APP_ENV = dev
add_path ($home + '/.local/share/composer/bin')

# Neovim
add_path ($home + '/.local/share/bob/nvim-bin')

# Node
if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env
    add_path $"($env.FNM_MULTISHELL_PATH)/bin"
    add_path $"($env.FNM_MULTISHELL_PATH)/"
}
add_path ($home + '/.yarn/bin')

# Deno
$env.DENO_INSTALL = ($home + '/.deno')
add_path ($env.DENO_INSTALL + '/bin')

# Pulumi
add_path ($home + '/.pulumi/bin')

# telemetry and ads
$env.DO_NOT_TRACK = 1
$env.ADBLOCK = 1
$env.STORYBOOK_DISABLE_TELEMETRY = 1
$env.DISABLE_OPENCOLLECTIVE = 1

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
