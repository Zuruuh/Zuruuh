# fnm
if type -q fnm
    set PATH "$HOME/.local/share/fnm" $PATH
    fnm env | source
end
