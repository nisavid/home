# Shell runtime configuration | Ruby environment


path_affix post "$HOME/.rvm/bin"


[[ $- == *i* ]] || return
# interactive shell -----------------------------------------------------------


# remove RVM bin paths because RVM expects them to be at the beginning of PATH
# but doesn't move them there when it's activated
export PATH="$(echo :$PATH | sed "s|:$HOME/\.rvm[^:]*/bin||g" | tail -c +2)"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
