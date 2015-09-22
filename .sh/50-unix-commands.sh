# Shell runtime configuration | customizations of common Unix commands


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
    alias grep='grep --line-number --color=auto'
    alias fgrep='fgrep --line-number --color=auto'
    alias egrep='egrep --line-number --color=auto'
fi


# file manipulation
if [[ -n "$(which colordiff 2> /dev/null)" ]]; then
    alias diff='colordiff --unified'
else
    alias diff='diff --unified'
fi
alias l='ls --format=vertical --classify'
alias la='l --almost-all'
alias lal='l --all --format=verbose'
alias ll='l --format=verbose'
alias lr='l --recursive'
