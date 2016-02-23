#!/bin/sh
# Shell configuration | core commands

if ! command -v realpath >/dev/null 2>&1; then
    realpath() {
        printf %s "$1" | command grep -q '^/' && printf %s "$1" || printf %s "$PWD/${1#./}"
    }
fi
