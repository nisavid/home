# Zsh runtime configuration | terminal setup

[[ $- == *i* ]] || return
# Interactive shell -----------------------------------------------------------

# History ---------------------------------------------------------------------

export HISTSIZE=1200000000
export SAVEHIST=1000000000

setopt extended_history
setopt no_hist_beep
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_no_store
setopt hist_verify
setopt inc_append_history
setopt no_share_history

# Key bindings ----------------------------------------------------------------

# Up ->
#   Recall the previous instance of the current line content as a substring in
#   the command history
bindkey '^[[A' history-substring-search-up
# Down ->
#   Recall the next instance of the current line content as a substring in the
#   command history
bindkey '^[[B' history-substring-search-down
# Right -> Move the cursor to the next character
bindkey "^[[C" vi-forward-char
# Left -> Move the cursor to the previous character
bindkey "^[[D" vi-backward-char
# End -> Move the cursor to the end of the line
bindkey "^[[F" vi-end-of-line
# Home -> Move the cursor to the beginning of the line
bindkey "^[[H" vi-beginning-of-line
# Backspace -> Delete the previous character
bindkey "^?" backward-delete-char
# Delete -> Delete the current character
bindkey "^[[3~" delete-char
