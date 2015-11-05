#!/bin/sh
# Shell runtime configuration | Ruby environment

path_affix post "$HOME/.rvm/bin"

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# remove RVM bin paths because RVM expects them to be at the beginning of PATH
# but doesn't move them there when it's activated
PATH="$(printf %s :"$PATH" | sed "s|:$HOME/\.rvm[^:]*/bin||g" | tail -c +2)"
export PATH

# shellcheck disable=SC1090
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"
