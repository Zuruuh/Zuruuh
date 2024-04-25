export def --env load-sh-env [file: string] {
    if not ($file | path exists) {
        error make {
            msg: 'Path does not exist',
            label: {
                text: 'path does not exist',
                span: (metadata $file).span
            }
        }
    }

    let base_env = do { sh -c 'env' } | complete  | get stdout | from dotenv

    do { sh -c $"source ($file) && env" } |
        complete |
        get stdout |
        from dotenv |
        items {|key, value| {
            $key: (
                if $key in $env.ENV_CONVERSIONS {
                    do ($env.ENV_CONVERSIONS | get $key | get from_string) $value
                } else {
                    $value
                }
            )
        }} |
        reduce --fold {} {|it, acc| $acc | merge $it} |
        transpose key value |
        filter {|kv|
            ($kv.key | is-not-empty) and (
                not ($kv.key in $base_env)
                or (($base_env | get $kv.key) != $kv.value)
            )
        } | reduce --fold {} {|it, acc| $acc | merge {$it.key: $it.value}} |
        load-env
}

export def --env load-env-file [file: string] {
    let base_env = do { sh -c 'env' } | complete | get stdout | from dotenv
    let parsed_env = cat .env |
        str trim |
        split row (char newline) |
        each {|str| $str | str trim} |
        filter {|str| $str !~ '^#' and ($str | is-not-empty)} |
        each {|str| $"export ($str)"} |
        str join (char newline)

    let with_env = do { sh -c $"($parsed_env) && env" } | complete | get stdout | from dotenv

    $with_env |
        transpose key value |
        filter {|kv|
            ($kv.key | is-not-empty) and (
                not ($kv.key in $base_env)
                or (($base_env | get $kv.key) != $kv.value)
            )
        } | reduce --fold {} {|it, acc| $acc | merge {$it.key: $it.value}} |
        load-env
}

def "from dotenv" [] {
    lines |
    str trim |
    each {split column '='} |
    each {values | flatten} |
    each {|kv| {
        $kv.0: ($kv |
            skip 1 |
            str join '=' |
            str trim --char (char single_quote) |
            str trim --char (char double_quote)
        )
    }} |
    default {} |
    reduce --fold {} {|it, acc| $acc | merge $it}
}
