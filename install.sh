#!/bin/bash
sh <(curl -L https://nixos.org/nix/install) --daemon
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

home-manager switch
