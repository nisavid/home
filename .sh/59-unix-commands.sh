#!/bin/sh
# Shell configuration | Unix commands

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

if [ -n "$LS_ARGS" ]; then
    unalias_if_exists ls
    ls() {
        # shellcheck disable=2086
        eval command ls $LS_ARGS "$@"
    }
fi
