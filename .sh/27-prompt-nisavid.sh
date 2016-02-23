#!/bin/sh
# Shell configuration | command prompt | Ivan D Vasin

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# Powerline
# shellcheck disable=SC1090
[ -f "$HOME"/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh ] \
    && [ -n "$(which powerline)" ] \
    && . "$HOME"/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh

# Promptline
# shellcheck disable=SC1090
[ -f "$HOME"/.promptline.sh ] && . "$HOME"/.promptline.sh
