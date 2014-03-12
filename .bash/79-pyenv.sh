# Bash runtime configuration | Python environment


# ensure interactive shell
[[ $- != *i* ]] && return


for pyenv in ${PYENV_CANDIDATES[@]}; do
    if [[ -f "$pyenv"/bin/activate ]]; then
        . "$pyenv"/bin/activate
        break
    fi
done
unset pyenv
