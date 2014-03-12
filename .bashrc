# Bash runtime configuration


# use GNU programs on MacPorts
# NOTE: this is intentionally not exported here
if [[ -d '/opt/local' ]]; then
    PATH="/opt/local/libexec/gnubin:$PATH"
fi


# external settings
for path in /etc/bashrc /etc/bash.bashrc /etc/bash/bashrc; do
    [[ -f "$path" ]] && . "$path"
done
skip_files=()
if [[ -d ~/.bash/ ]]; then
    for file in $(find ~/.bash/ -maxdepth 1 -regex '.*/[^.][^/]*' | sort); do
        skip=
        for file_ in ${skip_files[*]}; do
            if [[ "$(echo $file | sed  's_'$HOME'/.bash/__')" \
                      == "$file_" ]]; then
                skip=1
            fi
        done
        if [[ ! "$skip" ]]; then
            . "$file"
        fi
    done
fi
