#!/bin/sh
# Shell configuration | Unix commands | SI units

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

if [ -x "$(which dircolors)" ]; then
    alias ls='ls --color=auto --si'
else
    alias ls='ls --si'
fi

alias df='df --si'
alias du='du --si'

date() {
    for arg in "$@"; do
        if echo "$arg" | grep -q '^+'; then
            command date "$@"
            return
        fi
    done

    command date +'%F %T %Z' "$@"
}
