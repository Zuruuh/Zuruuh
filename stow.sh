#!/usr/bin/env bash

set -ve

stow --target="$HOME" -v home
sudo stow --target=/ -v root
