# shellcheck shell=sh
# Shell configuration | Unix commands | Colored output | dircolors

if [ -r "$HOME"/.dircolors ]; then \
    eval "$(dircolors -b "$HOME"/.dircolors)"
else
    eval "$(dircolors -b)"
fi

unalias_if_exists dir
dir() {
    command dir --color=auto "$@"
}

LS_ARGS="$(printf %s "$LS_ARGS --color=auto" | xargs)"

unalias_if_exists egrep
egrep() {
    command egrep --color=auto "$@"
}

unalias_if_exists egr
egr() {
    # shellcheck disable=SC2196
    egrep --line-number "$@"
}
complete_alias egr egrep

unalias_if_exists fgrep
fgrep() {
    command fgrep --color=auto "$@"
}

unalias_if_exists fgr
fgr() {
    # shellcheck disable=SC2197
    fgrep --line-number "$@"
}
complete_alias fgr fgrep

unalias_if_exists grep
grep() {
    command grep --color=auto "$@"
}

unalias_if_exists vdir
vdir() {
    command vdir --color=auto "$@"
}
