#!/usr/bin/env nu

let asciis = '~/.dotfiles/home/.config/nvim/asciis.jsonl'

def main [] {
    mut page = 0

    try {
        rm $asciis
    }

    loop {
        $page += 1
        let response = http get $"https://core.dollex.io/asciis?search=&type=featured&page=($page)"

        $response.data |
            select title data |
            filter {|ascii|
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
