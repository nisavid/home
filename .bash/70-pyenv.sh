# Bash runtime configuration | Python environment


# ensure interactive shell
[[ $- != *i* ]] && return


declare -a PYENV_CANDIDATES
