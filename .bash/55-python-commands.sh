# Bash runtime configuration | customizations of Python commands


# ensure interactive shell
[[ $- != *i* ]] && return


# environments
alias d='deactivate'


# shells
alias pysh='ipython --profile=pysh'
