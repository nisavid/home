# Bash runtime configuration | terminal setup


[[ $- == *i* ]] || return
# interactive shell -----------------------------------------------------------


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


# command and argument completion
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
    . /etc/bash_completion
elif [[ -f "$BREW_PREFIX"/etc/bash_completion ]]; then
    . "$BREW_PREFIX"/etc/bash_completion
elif [[ -f /opt/local/etc/profile.d/bash_completion.sh ]]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi
