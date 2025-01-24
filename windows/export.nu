#!/usr/bin/env nu

scoop export | save -f ~/.dotfiles/windows/scoop.json
winget export -o ~/.dotfiles/windows/winget.json
codium --list-extensions |
    split row (char newline) |
    to json --indent 4 |
    save -f ~/.dotfiles/home/.config/vscodium.extensions.jsonc
