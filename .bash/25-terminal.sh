#!/bin/bash
# Bash configuration | terminal setup

[[ $- == *i* ]] || return
# Interactive shell -----------------------------------------------------------

# shell options
# see: http://wiki.bash-hackers.org/internals/shell_options

shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s histappend

if [[ "${BASH_VERSINFO[0]}" -ge 4 ]]; then
    shopt -s autocd
    shopt -s checkjobs
    shopt -s globstar
fi

# Completion ------------------------------------------------------------------

if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    # shellcheck disable=SC1091
    source /etc/bash_completion
elif [[ -f "$BREW_PREFIX"/etc/bash_completion ]]; then
    # shellcheck disable=SC1090
    source "$BREW_PREFIX"/etc/bash_completion
elif [[ -f /opt/local/etc/profile.d/bash_completion.sh ]]; then
    # shellcheck disable=SC1091
    source /opt/local/etc/profile.d/bash_completion.sh
fi
