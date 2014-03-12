# Bash runtime configuration
# | customizations of common Unix commands
# | Ivan D Vasin


# ensure interactive shell
[[ $- != *i* ]] && return


# colored output
if [[ -x "$(which dircolors)" ]]; then
    test -r "$HOME"/.dircolors \
     && eval $(dircolors -b ~/.dircolors) \
     || eval $(dircolors -b)
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
