# shellcheck disable=SC2034,SC2153,SC2086,SC2155

# Above line is because shellcheck doesn't support zsh, per
# https://github.com/koalaman/shellcheck/wiki/SC1071, and the ignore: param in
# ludeeus/action-shellcheck only supports _directories_, not _files_. So
# instead, we manually add any error the shellcheck step finds in the file to
# the above line ...

# Source this in your ~/.zshrc
autoload -U add-zsh-hook

export ATUIN_SESSION=$(atuin uuid)
export ATUIN_HISTORY="atuin history list"

_atuin_preexec() {
    local id
    id=$(atuin history start -- "$1")
    export ATUIN_HISTORY_ID="$id"
}

_atuin_precmd() {
    local EXIT="$?"

    [[ -z "${ATUIN_HISTORY_ID}" ]] && return

    (RUST_LOG=error atuin history end --exit $EXIT -- $ATUIN_HISTORY_ID &) >/dev/null 2>&1
}

_atuin_search() {
    emulate -L zsh
    zle -I

    # Switch to cursor mode, then back to application
    echoti rmkx
    # swap stderr and stdout, so that the tui stuff works
    # TODO: not this
    # shellcheck disable=SC2048
    output=$(RUST_LOG=error atuin search $* -i -- $BUFFER 3>&1 1>&2 2>&3)
    echoti smkx

    if [[ -n $output ]]; then
        RBUFFER=""
        LBUFFER=$output
    fi

    zle reset-prompt
}

_atuin_up_search() {
    _atuin_search --shell-up-key-binding
}

add-zsh-hook preexec _atuin_preexec
add-zsh-hook precmd _atuin_precmd

zle -N _atuin_search_widget _atuin_search
zle -N _atuin_up_search_widget _atuin_up_search

bindkey '^r' _atuin_search_widget
bindkey '^[[A' _atuin_up_search_widget
bindkey '^[OA' _atuin_up_search_widget
#compdef atuin

autoload -U is-at-least

_atuin() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
":: :_atuin_commands" \
"*::: :->atuin" \
&& ret=0
    case $state in
    (atuin)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-command-$line[1]:"
        case $line[1] in
            (history)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
":: :_atuin__history_commands" \
"*::: :->history" \
&& ret=0

    case $state in
    (history)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-history-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
'*::command:' \
&& ret=0
;;
(end)
_arguments "${_arguments_options[@]}" \
'-e+[]:EXIT: ' \
'--exit=[]:EXIT: ' \
'-h[Print help]' \
'--help[Print help]' \
':id:' \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" \
'-f+[Available variables\: {command}, {directory}, {duration}, {user}, {host} and {time}. Example\: --format "{time} - \[{duration}\] - {directory}\$\\t{command}"]:FORMAT: ' \
'--format=[Available variables\: {command}, {directory}, {duration}, {user}, {host} and {time}. Example\: --format "{time} - \[{duration}\] - {directory}\$\\t{command}"]:FORMAT: ' \
'-c[]' \
'--cwd[]' \
'-s[]' \
'--session[]' \
'--human[]' \
'--cmd-only[Show only the text of the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(last)
_arguments "${_arguments_options[@]}" \
'-f+[Available variables\: {command}, {directory}, {duration}, {user}, {host} and {time}. Example\: --format "{time} - \[{duration}\] - {directory}\$\\t{command}"]:FORMAT: ' \
'--format=[Available variables\: {command}, {directory}, {duration}, {user}, {host} and {time}. Example\: --format "{time} - \[{duration}\] - {directory}\$\\t{command}"]:FORMAT: ' \
'--human[]' \
'--cmd-only[Show only the text of the command]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_atuin__history__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-history-help-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(end)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(last)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(import)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
":: :_atuin__import_commands" \
"*::: :->import" \
&& ret=0

    case $state in
    (import)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-import-command-$line[1]:"
        case $line[1] in
            (auto)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(zsh)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(zsh-hist-db)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(bash)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(resh)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(fish)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(nu)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(nu-hist-db)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_atuin__import__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-import-help-command-$line[1]:"
        case $line[1] in
            (auto)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(zsh)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(zsh-hist-db)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(bash)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(resh)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(fish)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(nu)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(nu-hist-db)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(stats)
_arguments "${_arguments_options[@]}" \
'-c+[How many top commands to list]:COUNT: ' \
'--count=[How many top commands to list]:COUNT: ' \
'-h[Print help]' \
'--help[Print help]' \
'*::period -- compute statistics for the specified period, leave blank for statistics since the beginning:' \
&& ret=0
;;
(search)
_arguments "${_arguments_options[@]}" \
'-c+[Filter search result by directory]:CWD: ' \
'--cwd=[Filter search result by directory]:CWD: ' \
'--exclude-cwd=[Exclude directory from results]:EXCLUDE_CWD: ' \
'-e+[Filter search result by exit code]:EXIT: ' \
'--exit=[Filter search result by exit code]:EXIT: ' \
'--exclude-exit=[Exclude results with this exit code]:EXCLUDE_EXIT: ' \
'-b+[Only include results added before this date]:BEFORE: ' \
'--before=[Only include results added before this date]:BEFORE: ' \
'--after=[Only include results after this date]:AFTER: ' \
'--limit=[How many entries to return at most]:LIMIT: ' \
'--offset=[Offset from the start of the results]:OFFSET: ' \
'--filter-mode=[Allow overriding filter mode over config]:FILTER_MODE:(global host session directory)' \
'--search-mode=[Allow overriding search mode over config]:SEARCH_MODE:(prefix full-text fuzzy skim)' \
'-f+[Available variables\: {command}, {directory}, {duration}, {user}, {host}, {time}, {exit} and {relativetime}. Example\: --format "{time} - \[{duration}\] - {directory}\$\\t{command}"]:FORMAT: ' \
'--format=[Available variables\: {command}, {directory}, {duration}, {user}, {host}, {time}, {exit} and {relativetime}. Example\: --format "{time} - \[{duration}\] - {directory}\$\\t{command}"]:FORMAT: ' \
'--inline-height=[Set the maximum number of lines Atuin'\''s interface should take up]:INLINE_HEIGHT: ' \
'-i[Open interactive search UI]' \
'--interactive[Open interactive search UI]' \
'--shell-up-key-binding[Marker argument used to inform atuin that it was invoked from a shell up-key binding (hidden from help to avoid confusion)]' \
'--human[Use human-readable formatting for time]' \
'--cmd-only[Show only the text of the command]' \
'--delete[Delete anything matching this query. Will not print out the match]' \
'--delete-it-all[Delete EVERYTHING!]' \
'-r[Reverse the order of results, oldest first]' \
'--reverse[Reverse the order of results, oldest first]' \
'-h[Print help]' \
'--help[Print help]' \
'*::query:' \
&& ret=0
;;
(sync)
_arguments "${_arguments_options[@]}" \
'-f[Force re-download everything]' \
'--force[Force re-download everything]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(login)
_arguments "${_arguments_options[@]}" \
'-u+[]:USERNAME: ' \
'--username=[]:USERNAME: ' \
'-p+[]:PASSWORD: ' \
'--password=[]:PASSWORD: ' \
'-k+[The encryption key for your account]:KEY: ' \
'--key=[The encryption key for your account]:KEY: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(logout)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(register)
_arguments "${_arguments_options[@]}" \
'-u+[]:USERNAME: ' \
'--username=[]:USERNAME: ' \
'-p+[]:PASSWORD: ' \
'--password=[]:PASSWORD: ' \
'-e+[]:EMAIL: ' \
'--email=[]:EMAIL: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(key)
_arguments "${_arguments_options[@]}" \
'--base64[Switch to base64 output of the key]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(status)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(account)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
":: :_atuin__account_commands" \
"*::: :->account" \
&& ret=0

    case $state in
    (account)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-account-command-$line[1]:"
        case $line[1] in
            (login)
_arguments "${_arguments_options[@]}" \
'-u+[]:USERNAME: ' \
'--username=[]:USERNAME: ' \
'-p+[]:PASSWORD: ' \
'--password=[]:PASSWORD: ' \
'-k+[The encryption key for your account]:KEY: ' \
'--key=[The encryption key for your account]:KEY: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(register)
_arguments "${_arguments_options[@]}" \
'-u+[]:USERNAME: ' \
'--username=[]:USERNAME: ' \
'-p+[]:PASSWORD: ' \
'--password=[]:PASSWORD: ' \
'-e+[]:EMAIL: ' \
'--email=[]:EMAIL: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(logout)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(delete)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_atuin__account__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-account-help-command-$line[1]:"
        case $line[1] in
            (login)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(register)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(logout)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(delete)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(server)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
":: :_atuin__server_commands" \
"*::: :->server" \
&& ret=0

    case $state in
    (server)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-server-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" \
'--host=[The host address to bind]:HOST: ' \
'-p+[The port to bind]:PORT: ' \
'--port=[The port to bind]:PORT: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_atuin__server__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-server-help-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
;;
(init)
_arguments "${_arguments_options[@]}" \
'--disable-ctrl-r[Disable the binding of CTRL-R to atuin]' \
'--disable-up-arrow[Disable the binding of the Up Arrow key to atuin]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
':shell:((zsh\:"Zsh setup"
bash\:"Bash setup"
fish\:"Fish setup"
nu\:"Nu setup"))' \
&& ret=0
;;
(uuid)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(contributors)
_arguments "${_arguments_options[@]}" \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(gen-completions)
_arguments "${_arguments_options[@]}" \
'-s+[Set the shell for generating completions]:SHELL:(bash elvish fish powershell zsh)' \
'--shell=[Set the shell for generating completions]:SHELL:(bash elvish fish powershell zsh)' \
'-o+[Set the output directory]:OUT_DIR: ' \
'--out-dir=[Set the output directory]:OUT_DIR: ' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_atuin__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-help-command-$line[1]:"
        case $line[1] in
            (history)
_arguments "${_arguments_options[@]}" \
":: :_atuin__help__history_commands" \
"*::: :->history" \
&& ret=0

    case $state in
    (history)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-help-history-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(end)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(list)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(last)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
(import)
_arguments "${_arguments_options[@]}" \
":: :_atuin__help__import_commands" \
"*::: :->import" \
&& ret=0

    case $state in
    (import)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-help-import-command-$line[1]:"
        case $line[1] in
            (auto)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(zsh)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(zsh-hist-db)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(bash)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(resh)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(fish)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(nu)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(nu-hist-db)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
(stats)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(search)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(sync)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(login)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(logout)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(register)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(key)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(status)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(account)
_arguments "${_arguments_options[@]}" \
":: :_atuin__help__account_commands" \
"*::: :->account" \
&& ret=0

    case $state in
    (account)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-help-account-command-$line[1]:"
        case $line[1] in
            (login)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(register)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(logout)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(delete)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
(server)
_arguments "${_arguments_options[@]}" \
":: :_atuin__help__server_commands" \
"*::: :->server" \
&& ret=0

    case $state in
    (server)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:atuin-help-server-command-$line[1]:"
        case $line[1] in
            (start)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
(init)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(uuid)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(contributors)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(gen-completions)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
}

(( $+functions[_atuin_commands] )) ||
_atuin_commands() {
    local commands; commands=(
'history:Manipulate shell history' \
'import:Import shell history from file' \
'stats:Calculate statistics for your history' \
'search:Interactive history search' \
'sync:Sync with the configured server' \
'login:Login to the configured server' \
'logout:Log out' \
'register:Register with the configured server' \
'key:Print the encryption key for transfer to another machine' \
'status:' \
'account:' \
'server:Start an atuin server' \
'init:Output shell setup' \
'uuid:Generate a UUID' \
'contributors:' \
'gen-completions:Generate shell completions' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin commands' commands "$@"
}
(( $+functions[_atuin__account_commands] )) ||
_atuin__account_commands() {
    local commands; commands=(
'login:Login to the configured server' \
'register:' \
'logout:Log out' \
'delete:' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin account commands' commands "$@"
}
(( $+functions[_atuin__help__account_commands] )) ||
_atuin__help__account_commands() {
    local commands; commands=(
'login:Login to the configured server' \
'register:' \
'logout:Log out' \
'delete:' \
    )
    _describe -t commands 'atuin help account commands' commands "$@"
}
(( $+functions[_atuin__help__import__auto_commands] )) ||
_atuin__help__import__auto_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help import auto commands' commands "$@"
}
(( $+functions[_atuin__import__auto_commands] )) ||
_atuin__import__auto_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import auto commands' commands "$@"
}
(( $+functions[_atuin__import__help__auto_commands] )) ||
_atuin__import__help__auto_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help auto commands' commands "$@"
}
(( $+functions[_atuin__help__import__bash_commands] )) ||
_atuin__help__import__bash_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help import bash commands' commands "$@"
}
(( $+functions[_atuin__import__bash_commands] )) ||
_atuin__import__bash_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import bash commands' commands "$@"
}
(( $+functions[_atuin__import__help__bash_commands] )) ||
_atuin__import__help__bash_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help bash commands' commands "$@"
}
(( $+functions[_atuin__contributors_commands] )) ||
_atuin__contributors_commands() {
    local commands; commands=()
    _describe -t commands 'atuin contributors commands' commands "$@"
}
(( $+functions[_atuin__help__contributors_commands] )) ||
_atuin__help__contributors_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help contributors commands' commands "$@"
}
(( $+functions[_atuin__account__delete_commands] )) ||
_atuin__account__delete_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account delete commands' commands "$@"
}
(( $+functions[_atuin__account__help__delete_commands] )) ||
_atuin__account__help__delete_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account help delete commands' commands "$@"
}
(( $+functions[_atuin__help__account__delete_commands] )) ||
_atuin__help__account__delete_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help account delete commands' commands "$@"
}
(( $+functions[_atuin__help__history__end_commands] )) ||
_atuin__help__history__end_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help history end commands' commands "$@"
}
(( $+functions[_atuin__history__end_commands] )) ||
_atuin__history__end_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history end commands' commands "$@"
}
(( $+functions[_atuin__history__help__end_commands] )) ||
_atuin__history__help__end_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history help end commands' commands "$@"
}
(( $+functions[_atuin__help__import__fish_commands] )) ||
_atuin__help__import__fish_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help import fish commands' commands "$@"
}
(( $+functions[_atuin__import__fish_commands] )) ||
_atuin__import__fish_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import fish commands' commands "$@"
}
(( $+functions[_atuin__import__help__fish_commands] )) ||
_atuin__import__help__fish_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help fish commands' commands "$@"
}
(( $+functions[_atuin__gen-completions_commands] )) ||
_atuin__gen-completions_commands() {
    local commands; commands=()
    _describe -t commands 'atuin gen-completions commands' commands "$@"
}
(( $+functions[_atuin__help__gen-completions_commands] )) ||
_atuin__help__gen-completions_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help gen-completions commands' commands "$@"
}
(( $+functions[_atuin__account__help_commands] )) ||
_atuin__account__help_commands() {
    local commands; commands=(
'login:Login to the configured server' \
'register:' \
'logout:Log out' \
'delete:' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin account help commands' commands "$@"
}
(( $+functions[_atuin__account__help__help_commands] )) ||
_atuin__account__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account help help commands' commands "$@"
}
(( $+functions[_atuin__help_commands] )) ||
_atuin__help_commands() {
    local commands; commands=(
'history:Manipulate shell history' \
'import:Import shell history from file' \
'stats:Calculate statistics for your history' \
'search:Interactive history search' \
'sync:Sync with the configured server' \
'login:Login to the configured server' \
'logout:Log out' \
'register:Register with the configured server' \
'key:Print the encryption key for transfer to another machine' \
'status:' \
'account:' \
'server:Start an atuin server' \
'init:Output shell setup' \
'uuid:Generate a UUID' \
'contributors:' \
'gen-completions:Generate shell completions' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin help commands' commands "$@"
}
(( $+functions[_atuin__help__help_commands] )) ||
_atuin__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help help commands' commands "$@"
}
(( $+functions[_atuin__history__help_commands] )) ||
_atuin__history__help_commands() {
    local commands; commands=(
'start:Begins a new command in the history' \
'end:Finishes a new command in the history (adds time, exit code)' \
'list:List all items in history' \
'last:Get the last command ran' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin history help commands' commands "$@"
}
(( $+functions[_atuin__history__help__help_commands] )) ||
_atuin__history__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history help help commands' commands "$@"
}
(( $+functions[_atuin__import__help_commands] )) ||
_atuin__import__help_commands() {
    local commands; commands=(
'auto:Import history for the current shell' \
'zsh:Import history from the zsh history file' \
'zsh-hist-db:Import history from the zsh history file' \
'bash:Import history from the bash history file' \
'resh:Import history from the resh history file' \
'fish:Import history from the fish history file' \
'nu:Import history from the nu history file' \
'nu-hist-db:Import history from the nu history file' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin import help commands' commands "$@"
}
(( $+functions[_atuin__import__help__help_commands] )) ||
_atuin__import__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help help commands' commands "$@"
}
(( $+functions[_atuin__server__help_commands] )) ||
_atuin__server__help_commands() {
    local commands; commands=(
'start:Start the server' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin server help commands' commands "$@"
}
(( $+functions[_atuin__server__help__help_commands] )) ||
_atuin__server__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'atuin server help help commands' commands "$@"
}
(( $+functions[_atuin__help__history_commands] )) ||
_atuin__help__history_commands() {
    local commands; commands=(
'start:Begins a new command in the history' \
'end:Finishes a new command in the history (adds time, exit code)' \
'list:List all items in history' \
'last:Get the last command ran' \
    )
    _describe -t commands 'atuin help history commands' commands "$@"
}
(( $+functions[_atuin__history_commands] )) ||
_atuin__history_commands() {
    local commands; commands=(
'start:Begins a new command in the history' \
'end:Finishes a new command in the history (adds time, exit code)' \
'list:List all items in history' \
'last:Get the last command ran' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin history commands' commands "$@"
}
(( $+functions[_atuin__help__import_commands] )) ||
_atuin__help__import_commands() {
    local commands; commands=(
'auto:Import history for the current shell' \
'zsh:Import history from the zsh history file' \
'zsh-hist-db:Import history from the zsh history file' \
'bash:Import history from the bash history file' \
'resh:Import history from the resh history file' \
'fish:Import history from the fish history file' \
'nu:Import history from the nu history file' \
'nu-hist-db:Import history from the nu history file' \
    )
    _describe -t commands 'atuin help import commands' commands "$@"
}
(( $+functions[_atuin__import_commands] )) ||
_atuin__import_commands() {
    local commands; commands=(
'auto:Import history for the current shell' \
'zsh:Import history from the zsh history file' \
'zsh-hist-db:Import history from the zsh history file' \
'bash:Import history from the bash history file' \
'resh:Import history from the resh history file' \
'fish:Import history from the fish history file' \
'nu:Import history from the nu history file' \
'nu-hist-db:Import history from the nu history file' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin import commands' commands "$@"
}
(( $+functions[_atuin__help__init_commands] )) ||
_atuin__help__init_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help init commands' commands "$@"
}
(( $+functions[_atuin__init_commands] )) ||
_atuin__init_commands() {
    local commands; commands=()
    _describe -t commands 'atuin init commands' commands "$@"
}
(( $+functions[_atuin__help__key_commands] )) ||
_atuin__help__key_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help key commands' commands "$@"
}
(( $+functions[_atuin__key_commands] )) ||
_atuin__key_commands() {
    local commands; commands=()
    _describe -t commands 'atuin key commands' commands "$@"
}
(( $+functions[_atuin__help__history__last_commands] )) ||
_atuin__help__history__last_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help history last commands' commands "$@"
}
(( $+functions[_atuin__history__help__last_commands] )) ||
_atuin__history__help__last_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history help last commands' commands "$@"
}
(( $+functions[_atuin__history__last_commands] )) ||
_atuin__history__last_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history last commands' commands "$@"
}
(( $+functions[_atuin__help__history__list_commands] )) ||
_atuin__help__history__list_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help history list commands' commands "$@"
}
(( $+functions[_atuin__history__help__list_commands] )) ||
_atuin__history__help__list_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history help list commands' commands "$@"
}
(( $+functions[_atuin__history__list_commands] )) ||
_atuin__history__list_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history list commands' commands "$@"
}
(( $+functions[_atuin__account__help__login_commands] )) ||
_atuin__account__help__login_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account help login commands' commands "$@"
}
(( $+functions[_atuin__account__login_commands] )) ||
_atuin__account__login_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account login commands' commands "$@"
}
(( $+functions[_atuin__help__account__login_commands] )) ||
_atuin__help__account__login_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help account login commands' commands "$@"
}
(( $+functions[_atuin__help__login_commands] )) ||
_atuin__help__login_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help login commands' commands "$@"
}
(( $+functions[_atuin__login_commands] )) ||
_atuin__login_commands() {
    local commands; commands=()
    _describe -t commands 'atuin login commands' commands "$@"
}
(( $+functions[_atuin__account__help__logout_commands] )) ||
_atuin__account__help__logout_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account help logout commands' commands "$@"
}
(( $+functions[_atuin__account__logout_commands] )) ||
_atuin__account__logout_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account logout commands' commands "$@"
}
(( $+functions[_atuin__help__account__logout_commands] )) ||
_atuin__help__account__logout_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help account logout commands' commands "$@"
}
(( $+functions[_atuin__help__logout_commands] )) ||
_atuin__help__logout_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help logout commands' commands "$@"
}
(( $+functions[_atuin__logout_commands] )) ||
_atuin__logout_commands() {
    local commands; commands=()
    _describe -t commands 'atuin logout commands' commands "$@"
}
(( $+functions[_atuin__help__import__nu_commands] )) ||
_atuin__help__import__nu_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help import nu commands' commands "$@"
}
(( $+functions[_atuin__import__help__nu_commands] )) ||
_atuin__import__help__nu_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help nu commands' commands "$@"
}
(( $+functions[_atuin__import__nu_commands] )) ||
_atuin__import__nu_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import nu commands' commands "$@"
}
(( $+functions[_atuin__help__import__nu-hist-db_commands] )) ||
_atuin__help__import__nu-hist-db_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help import nu-hist-db commands' commands "$@"
}
(( $+functions[_atuin__import__help__nu-hist-db_commands] )) ||
_atuin__import__help__nu-hist-db_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help nu-hist-db commands' commands "$@"
}
(( $+functions[_atuin__import__nu-hist-db_commands] )) ||
_atuin__import__nu-hist-db_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import nu-hist-db commands' commands "$@"
}
(( $+functions[_atuin__account__help__register_commands] )) ||
_atuin__account__help__register_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account help register commands' commands "$@"
}
(( $+functions[_atuin__account__register_commands] )) ||
_atuin__account__register_commands() {
    local commands; commands=()
    _describe -t commands 'atuin account register commands' commands "$@"
}
(( $+functions[_atuin__help__account__register_commands] )) ||
_atuin__help__account__register_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help account register commands' commands "$@"
}
(( $+functions[_atuin__help__register_commands] )) ||
_atuin__help__register_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help register commands' commands "$@"
}
(( $+functions[_atuin__register_commands] )) ||
_atuin__register_commands() {
    local commands; commands=()
    _describe -t commands 'atuin register commands' commands "$@"
}
(( $+functions[_atuin__help__import__resh_commands] )) ||
_atuin__help__import__resh_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help import resh commands' commands "$@"
}
(( $+functions[_atuin__import__help__resh_commands] )) ||
_atuin__import__help__resh_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help resh commands' commands "$@"
}
(( $+functions[_atuin__import__resh_commands] )) ||
_atuin__import__resh_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import resh commands' commands "$@"
}
(( $+functions[_atuin__help__search_commands] )) ||
_atuin__help__search_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help search commands' commands "$@"
}
(( $+functions[_atuin__search_commands] )) ||
_atuin__search_commands() {
    local commands; commands=()
    _describe -t commands 'atuin search commands' commands "$@"
}
(( $+functions[_atuin__help__server_commands] )) ||
_atuin__help__server_commands() {
    local commands; commands=(
'start:Start the server' \
    )
    _describe -t commands 'atuin help server commands' commands "$@"
}
(( $+functions[_atuin__server_commands] )) ||
_atuin__server_commands() {
    local commands; commands=(
'start:Start the server' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'atuin server commands' commands "$@"
}
(( $+functions[_atuin__help__history__start_commands] )) ||
_atuin__help__history__start_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help history start commands' commands "$@"
}
(( $+functions[_atuin__help__server__start_commands] )) ||
_atuin__help__server__start_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help server start commands' commands "$@"
}
(( $+functions[_atuin__history__help__start_commands] )) ||
_atuin__history__help__start_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history help start commands' commands "$@"
}
(( $+functions[_atuin__history__start_commands] )) ||
_atuin__history__start_commands() {
    local commands; commands=()
    _describe -t commands 'atuin history start commands' commands "$@"
}
(( $+functions[_atuin__server__help__start_commands] )) ||
_atuin__server__help__start_commands() {
    local commands; commands=()
    _describe -t commands 'atuin server help start commands' commands "$@"
}
(( $+functions[_atuin__server__start_commands] )) ||
_atuin__server__start_commands() {
    local commands; commands=()
    _describe -t commands 'atuin server start commands' commands "$@"
}
(( $+functions[_atuin__help__stats_commands] )) ||
_atuin__help__stats_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help stats commands' commands "$@"
}
(( $+functions[_atuin__stats_commands] )) ||
_atuin__stats_commands() {
    local commands; commands=()
    _describe -t commands 'atuin stats commands' commands "$@"
}
(( $+functions[_atuin__help__status_commands] )) ||
_atuin__help__status_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help status commands' commands "$@"
}
(( $+functions[_atuin__status_commands] )) ||
_atuin__status_commands() {
    local commands; commands=()
    _describe -t commands 'atuin status commands' commands "$@"
}
(( $+functions[_atuin__help__sync_commands] )) ||
_atuin__help__sync_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help sync commands' commands "$@"
}
(( $+functions[_atuin__sync_commands] )) ||
_atuin__sync_commands() {
    local commands; commands=()
    _describe -t commands 'atuin sync commands' commands "$@"
}
(( $+functions[_atuin__help__uuid_commands] )) ||
_atuin__help__uuid_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help uuid commands' commands "$@"
}
(( $+functions[_atuin__uuid_commands] )) ||
_atuin__uuid_commands() {
    local commands; commands=()
    _describe -t commands 'atuin uuid commands' commands "$@"
}
(( $+functions[_atuin__help__import__zsh_commands] )) ||
_atuin__help__import__zsh_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help import zsh commands' commands "$@"
}
(( $+functions[_atuin__import__help__zsh_commands] )) ||
_atuin__import__help__zsh_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help zsh commands' commands "$@"
}
(( $+functions[_atuin__import__zsh_commands] )) ||
_atuin__import__zsh_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import zsh commands' commands "$@"
}
(( $+functions[_atuin__help__import__zsh-hist-db_commands] )) ||
_atuin__help__import__zsh-hist-db_commands() {
    local commands; commands=()
    _describe -t commands 'atuin help import zsh-hist-db commands' commands "$@"
}
(( $+functions[_atuin__import__help__zsh-hist-db_commands] )) ||
_atuin__import__help__zsh-hist-db_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import help zsh-hist-db commands' commands "$@"
}
(( $+functions[_atuin__import__zsh-hist-db_commands] )) ||
_atuin__import__zsh-hist-db_commands() {
    local commands; commands=()
    _describe -t commands 'atuin import zsh-hist-db commands' commands "$@"
}

if [ "$funcstack[1]" = "_atuin" ]; then
    _atuin "$@"
else
    compdef _atuin atuin
fi
