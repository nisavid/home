#!/bin/bash
# Bash configuration | development

[[ $- == *i* ]] || return
# Interactive shell -----------------------------------------------------------

# Completion ------------------------------------------------------------------

_aws_completer="$(command -v aws_completer)"
[[ $? -eq 0 ]] && complete -C "$_aws_completer" aws
