#!/usr/bin/env nu
scoop export | save -f ~/.dotfiles/windows/scoop.json
winget export -o ~/.dotfiles/windows/winget.json
