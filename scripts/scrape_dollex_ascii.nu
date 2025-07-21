#!/usr/bin/env nu

let asciis = ('~/.dotfiles/home/.config/nvim/asciis.jsonl' | path expand)

def main [] {
    mut page = 0

    if ($asciis | path exists) {
        rm $asciis
    }

    loop {
        $page += 1
        let response = http get $"https://core.dollex.io/asciis?search=&type=featured&page=($page)"

        $response.data |
            select title data |
            where {|ascii|
                $ascii.data | str contains (char newline)
            } |
            each {|ascii| $ascii |
                to json -r |
                $"($in)(char newline)" |
                save -a $asciis
            }

        if not $response.meta.hasNextPage {
            break;
        }
    }
}
