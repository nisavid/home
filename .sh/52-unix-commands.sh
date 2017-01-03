#!/bin/sh
# Shell configuration | Unix commands

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# Colored output --------------------------------------------------------------

unalias_if_exists diff
if [ -n "$(command -v colordiff 2> /dev/null)" ]; then
    diff() {
        colordiff --unified "$@"
    }
else
    diff() {
        command diff --unified "$@"
    }
fi

if [ -n "$(command -v dircolors 2> /dev/null)" ]; then
    if [ -r "$HOME"/.dircolors ]; then \
        eval "$(dircolors -b "$HOME"/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi

    unalias_if_exists dir
    dir() {
        command dir --color=auto "$@"
    }

    unalias_if_exists ls
    ls() {
        command ls --color=auto "$@"
    }

    unalias_if_exists egrep
    egrep() {
        command egrep --color=auto "$@"
    }

    unalias_if_exists fgrep
    fgrep() {
        command fgrep --color=auto "$@"
    }

    unalias_if_exists grep
    grep() {
        command grep --color=auto "$@"
    }

    unalias_if_exists vdir
    vdir() {
        command vdir --color=auto "$@"
    }
fi

# File manipulation -----------------------------------------------------------

unalias_if_exists gr
gr() {
    grep --line-number "$@"
}
complete_alias gr grep

unalias_if_exists fgr
fgr() {
    fgrep --line-number "$@"
}
complete_alias fgr fgrep

unalias_if_exists egr
egr() {
    egrep --line-number "$@"
}
complete_alias egr egrep

unalias_if_exists l
l() {
    ls --format=vertical --classify "$@"
}
complete_alias l ls

unalias_if_exists la
la() {
    l --almost-all "$@"
}
complete_alias la ls

unalias_if_exists lal
lal() {
    l --all --format=verbose "$@"
}
complete_alias lal ls

unalias_if_exists ll
ll() {
    l --format=verbose "$@"
}
complete_alias ll ls

unalias_if_exists lr
lr() {
    l --recursive "$@"
}
complete_alias lr ls

unalias_if_exists mkd
mkd() {
    mkdir "$@"
}
complete_alias mkd mkdir

# Systems administration ------------------------------------------------------

# make the current user's aliases available to sudo
# TODOC: why does this work?
alias sudo='sudo '
