# Bash runtime configuration | Ivan D Vasin


# ensure interactive shell
[[ $- != *i* ]] && return


# aliases

# Python
alias ipy='ipython'

# Vim sessions
alias vapb="vim '+SessionOpen ansible-playbooks'"
alias vbf="vim '+SessionOpen bedframe'"
alias vbfa="vim '+SessionOpen bedframe-auth'"
alias vdl="vim '+SessionOpen deli'"
alias vnp="vim '+SessionOpen napper'"
alias vpsl="vim '+SessionOpen px-shortlinks'"
alias vscoll="vim '+SessionOpen spruce-collections'"
alias vsdb="vim '+SessionOpen spruce-db'"
alias vsdt="vim '+SessionOpen spruce-datetime'"
alias vslang="vim '+SessionOpen spruce-lang'"
alias vspkg="vim '+SessionOpen spruce-pkg'"
alias vsset="vim '+SessionOpen spruce-settings'"
alias vsuri="vim '+SessionOpen spruce-uri'"
alias vtb="vim '+SessionOpen testbed'"
