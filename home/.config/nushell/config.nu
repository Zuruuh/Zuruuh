$env.config.show_banner = false

$env.config.history = {
    max_size: 100_000
    sync_on_enter: true
    file_format: "sqlite"
    isolation: true
}

$env.config.completions = {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
    use_ls_colors: true
}

if $nu.os-info.family == 'unix' {
    $env.config.completions.external = {
        enable: true
        completer: {|spans|
            fish --command $'complete "--do-complete=($spans | str join " ")"'
            | from tsv --flexible --noheaders --no-infer
            | rename value description
            | update value {
                if ($in | str contains ' ') and ($in | path exists) {
                    $'"($in | str replace "\"" "\\\"" )"'
                } else {
                    $in
                }
            }
        }
    }
}

$env.config.cursor_shape = {
    emacs: line
    vi_insert: block
    vi_normal: underscore
}

$env.config.footer_mode = "auto"
$env.config.edit_mode = 'vi'
$env.config.use_ansi_coloring = true

$env.config.shell_integration = {
    osc2: true
    osc7: true
    osc8: true
    osc9_9: true
    osc133: true
    osc633: true
}

$env.config.render_right_prompt_on_last_line = false
$env.config.hooks.pre_prompt = [{ ||
    try {
        direnv export json | from json | default {} | load-env
    }
}]

$env.config.menus = [
    {
        name: ide_completion_menu
        only_buffer_difference: false
        marker: "> "
        type: {
            layout: ide
            min_completion_width: 0,
            max_completion_width: 50,
            max_completion_height: 15, # will be limited by the available lines in the terminal
            padding: 0,
            border: true,
            cursor_offset: 0,
            description_mode: "prefer_right"
            min_description_width: 0
            max_description_width: 50
            max_description_height: 10
            description_offset: 1
        }
        style: {
            text: green
            selected_text: green_reverse
            description_text: yellow
        }
    }
]

$env.config.keybindings = $env.config.keybindings |
    default [] |
    append {
        name: ide_completion_menu
        modifier: none
        keycode: tab
        mode: [emacs vi_normal vi_insert]
        event: {
            until: [
                { send: menu name: ide_completion_menu }
                { send: menunext }
                { edit: complete }
            ]
        }
    }

source ~/.config/nushell/plugins.nu
