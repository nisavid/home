# Shell runtime configuration | Python environment


for pyenv in ${PYENVS[@]}; do
    if [[ -f "$pyenv"/bin/activate ]]; then
        source "$pyenv"/bin/activate
        break
    fi
done
unset pyenv
