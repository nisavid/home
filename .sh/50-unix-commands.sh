#!/bin/sh
# Shell configuration | Unix commands

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# Colored output --------------------------------------------------------------

if [ -n "$(command -v dircolors 2> /dev/null)" ]; then
    if [ -r "$HOME"/.dircolors ]; then \
        eval "$(dircolors -b "$HOME"/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --line-number --color=auto'
    alias fgrep='fgrep --line-number --color=auto'
    alias egrep='egrep --line-number --color=auto'
fi

if [ -n "$(command -v colordiff 2> /dev/null)" ]; then
    alias diff='colordiff --unified'
else
    alias diff='diff --unified'
fi

# File manipulation -----------------------------------------------------------

alias l='ls --format=vertical --classify'
alias la='l --almost-all'
alias lal='l --all --format=verbose'
alias ll='l --format=verbose'
alias lr='l --recursive'
alias mkd='mkdir'

# Systems administration ------------------------------------------------------

# make the current user's aliases available to sudo
# TODOC: why does this work?
alias sudo='sudo '
