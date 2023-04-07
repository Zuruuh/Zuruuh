#!/bin/bash
# 0 * * * *

files=(".config/nvim" ".zshrc" ".zshenv" ".gitconfig" ".gitignore")

cd $HOME/dev/dotfiles

for file in ${files[@]}; do
    rg -qv '/' <<< "$file"
    has_subdir=$?
    # fd -Ht f
    if [[ $has_subdir = 0 ]]; then
        echo "Syncing file $HOME/$file to $PWD/$file"
        rsync "$HOME/$file" "$file"
    else
        echo "Syncing dir $HOME/$file to $PWD/$file"
        cd $HOME
        fd . $file -Ht f -x bash -c "mkdir -p $HOME/dev/dotfiles/{//}; rsync {} $HOME/dev/dotfiles/{}"
        cd -
    fi
done;
