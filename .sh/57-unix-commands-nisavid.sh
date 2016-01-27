#!/bin/sh
# Shell runtime configuration | customizations of common Unix commands | Ivan D Vasin

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# colored output
if [ -x "$(which dircolors)" ]; then
    alias ls='ls --color=auto --si'
else
    alias ls='ls --si'
fi

# file manipulation
alias df='df --si'
alias du='du --si'

# systems administration
# make the current user's aliases available to sudo
# TODOC: why does this work?
alias sudo='sudo '

# miscellany
date() {
    for arg in "$@"; do
        if echo "$arg" | grep -q '^+'; then
            command date "$@"
            return
        fi
    done

    command date +'%F %T %Z' "$@"
}
