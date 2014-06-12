# Bash runtime configuration | Python environment


for pyenv in ${PYENV_CANDIDATES[@]}; do
    if [[ -f "$pyenv"/bin/activate ]]; then
        . "$pyenv"/bin/activate
        break
    fi
done
unset pyenv
