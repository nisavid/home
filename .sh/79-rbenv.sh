# Shell runtime configuration | Ruby environment


pathmunge "$HOME/.rvm/bin" after


[[ $- == *i* ]] || return
# interactive shell -----------------------------------------------------------


[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
