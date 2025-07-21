export def --env load-sh-env [file: string] {
    if (which sh | is-empty) {
        print $"Tried to load file ($file) but no SH executor was found?"

        return
    }

    if not ($file | path exists) {
        error make {
            msg: 'Path does not exist',
            label: {
                text: 'path does not exist',
                span: (metadata $file).span
            }
        }
    }

    let base_env = do { sh -c 'env -0' } | complete  | get stdout | from dotenv

    do { sh -c $"source ($file) && env -0" } |
        complete |
        get stdout |
        from dotenv |
        transpose key value |
        where {|kv|
            if ($kv.key | is-empty) {
                return false
            }

            (not ($kv.key in $base_env)) or (($base_env | get $kv.key) != $kv.value)
        } |
        reduce --fold {} {|it, acc| $acc | merge {$it.key: $it.value}} |
        load-env
}

def "from dotenv" [] {
    split row (char null_byte) |
    str trim |
    where {is-not-empty} |
    parse '{key}={value}' |
    default {} |
    transpose -r |
    get 0
}
