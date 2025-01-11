#!/usr/bin/env nu

scoop update --all
winget update --all
nu ~/.dotfiles/windows/export.nu
