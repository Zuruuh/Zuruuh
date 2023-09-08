if (ls ~/.config/nushell/plugins | filter {|$file| $file.name =~ 'nu_scripts'} | is-empty) {
    git clone https://github.com/nushell/nu_scripts ~/.config/nushell/plugins/nu_scripts
}
