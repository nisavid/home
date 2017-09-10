# shellcheck shell=sh
# Shell configuration | Unix commands

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

if [ -n "$LS_ARGS" ]; then
    # shellcheck disable=SC1090
    . "$HOME"/.sh/lib/unix-commands-lsargs.sh
fi
