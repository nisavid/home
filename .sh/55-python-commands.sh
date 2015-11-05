#!/bin/sh
# Shell runtime configuration | customizations of Python commands

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# environments
alias d='deactivate'

# shells
alias pysh='ipython --profile=pysh'
