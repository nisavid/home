# Bash runtime configuration | command prompt | Ivan D Vasin


# ensure interactive shell
[[ $- != *i* ]] && return


# Powerline
[[ -f "$HOME"/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh
    && -n "$(which powerline)" ]] \
 && . "$HOME"/.vim/bundle/powerline/powerline/bindings/bash/powerline.sh

# Promptline
[[ -f "$HOME"/.promptline.sh ]] && . "$HOME"/.promptline.sh
