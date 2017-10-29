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
