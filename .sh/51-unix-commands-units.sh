#!/bin/sh
# Shell configuration | Unix commands | SI units

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# Units -----------------------------------------------------------------------

unalias_if_exists ls
if [ -x "$(which dircolors)" ]; then
    ls() {
        command ls --color=auto --si "$@"
    }
else
    ls() {
        command ls --si "$@"
    }
fi

unalias_if_exists df
df() {
    command df --si "$@"
}

unalias_if_exists du
du() {
    command du --si "$@"
}

unalias_if_exists date
date() {
    for arg in "$@"; do
        if echo "$arg" | grep -q '^+'; then
            command date "$@"
            return
        fi
    done

    command date +'%F %T %Z' "$@"
}
