# Zsh runtime configuration | terminal setup


[[ $- == *i* ]] || return
# interactive shell -----------------------------------------------------------


# key bindings

# Up -> Recall the previous instance of the input as a substring in the command
#       history
bindkey '^[[A' history-substring-search-up
# Down -> Recall the next instance of the input as a substring in the command
#         history
bindkey '^[[B' history-substring-search-down
# Right -> Move the cursor to the next character
bindkey "^[[C" vi-forward-char
# Left -> Move the cursor to the previous character
bindkey "^[[D" vi-backward-char
# End -> Move the cursor to the end of the line
bindkey "^[[F" vi-end-of-line
# Home -> Move the cursor to the beginning of the line
bindkey "^[[H" vi-beginning-of-line
