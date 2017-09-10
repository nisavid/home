# shellcheck shell=bash
# Zsh configuration | development

[[ $- == *i* ]] || return
# Interactive shell -----------------------------------------------------------

# Completion ------------------------------------------------------------------

_aws_completer="$(command -v aws_zsh_completer.sh)"
# shellcheck disable=SC1090
[[ $? -eq 0 ]] && source "$_aws_completer"
