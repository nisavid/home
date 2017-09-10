# shellcheck shell=sh
# Shell configuration | Ruby environment

path_affix post "$HOME/.rvm/bin"

while [ -n "$RUBYDB_LIBS" ]; do
    _rubydb_lib="${RUBYDB_LIBS%%:*}"

    if [ -e "$_rubydb_lib" ]; then
        # shellcheck disable=SC1090
        export RUBYDB_LIB="$_rubydb_lib"
        break
    fi

    if [ "$RUBYDB_LIBS" = "$_rubydb_lib" ]; then
        RUBYDB_LIBS=''
    else
        RUBYDB_LIBS="${RUBYDB_LIBS#*:}"
    fi
done
unset _rubydb_lib

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# remove RVM bin paths because RVM expects them to be at the beginning of PATH
# but doesn't move them there when it's activated
PATH="$(printf %s :"$PATH" | sed "s|:$HOME/\.rvm[^:]*/bin||g" | tail -c +2)"
export PATH

# shellcheck disable=SC1090
if [ -s "$HOME/.rvm/scripts/rvm" ]; then . "$HOME/.rvm/scripts/rvm"; fi
