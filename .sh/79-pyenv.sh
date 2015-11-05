#!/bin/sh
# Shell runtime configuration | Python environment

while [ -n "$PYENVS" ] && [ ! "$abort" ]; do
    _pyenv="${PYENVS%%:*}"

    if [ -e "$_pyenv" ]; then
        # shellcheck disable=SC1090
        source "$_pyenv"/bin/activate
        break
    fi

    if [ "$PYENVS" = "$_pyenv" ]; then
        PYENVS=''
    else
        PYENVS="${PYENVS#*:}"
    fi
done
unset _pyenv
