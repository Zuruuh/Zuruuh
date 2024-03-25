export def --env load-env-file [file: string] {
    let base_env = do { bash -c 'env' } | complete | get stdout | from dotenv
    let parsed_env = cat .env |
        str trim |
        split row (char newline) |
        each {|string| if $string =~ '^#' or ($string | is-empty) {
                null
            } else {
                'export ' + $string
            }
        } |
        filter {|str| $str != null} |
        str join (char newline)

    let with_env = do { bash -c $"($parsed_env) && env" } | complete | get stdout | from dotenv

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
    str trim |
    split row (char newline) |
    each {|line| split column '='} |
    each {|kv|
        let kv = $kv | values | flatten
        let key = $kv.0
        let value = $kv |
            skip 1 |
            str join '=' |
            str trim --char '"' |
            str trim --char "'"

        return {$key: $value}
    } |
    reduce {|it, acc| $acc | merge $it}
}
