#!/bin/sh
# Shell configuration | core commands

if ! which realpath >/dev/null 2>&1; then
    realpath() {
        printf %s "$1" | command grep -q '^/' && printf %s "$1" || printf %s "$PWD/${1#./}"
    }
fi

if ! which app_open >/dev/null 2>&1; then
    if which xdg-open >/dev/null 2>&1; then
        app_open() {
            xdg-open "$@"
        }
    elif [ "$(uname -s)" = 'Darwin' ] && which open >/dev/null 2>&1; then
        app_open() {
            open "$@"
        }
    fi
fi
