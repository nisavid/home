#!/bin/sh
# Shell configuration | customizations of common Unix commands

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# colored output
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


# file manipulation
if [ -n "$(command -v colordiff 2> /dev/null)" ]; then
    alias diff='colordiff --unified'
else
    alias diff='diff --unified'
fi

alias l='ls --format=vertical --classify'
alias la='l --almost-all'
alias lal='l --all --format=verbose'
alias ll='l --format=verbose'
alias lr='l --recursive'
