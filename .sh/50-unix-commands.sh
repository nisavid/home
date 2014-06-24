# Bash runtime configuration | customizations of common Unix commands


[[ $- == *i* ]] || return
# interactive shell -----------------------------------------------------------


# colored output
if [[ -n "$(which dircolors 2> /dev/null)" ]]; then
    test -r ~/.dircolors \
     && eval "$(dircolors -b ~/.dircolors)" \
     || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# file manipulation
if [[ -n "$(which colordiff 2> /dev/null)" ]]; then
    alias diff='colordiff --unified'
else
    alias diff='diff --unified'
fi
alias l='ls --format=vertical --classify'
alias la='ls --almost-all'
alias lal='ls --all --format=verbose --classify'
alias ll='ls --format=verbose --classify'
alias lr='ls --recursive'
