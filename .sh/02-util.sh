#!/bin/sh
# Shell configuration | utilities

# Shell configuration ---------------------------------------------------------

alias shrc='. "$HOME"/.shrc'

# Quoting ---------------------------------------------------------------------

quote() {
    printf %s "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/"
}

# Directories -----------------------------------------------------------------

in_dir() {
    cd "$1" || return
    shift

    "$@"
    _ret=$?

    cd - >/dev/null || return

    return $_ret
}

# Variable manipulation -------------------------------------------------------

affix_to_path_var() {
    _var="$1"
    _position="$2"
    _entry="$3"

    [ ! -d "$_entry" ] && { unset _var _position _entry; return; }

    # strip entry from beginning, middle, and end
    _value="$(eval "printf %s \$$_var")"
    _value="$(printf %s "${_value#${_entry}:}" | sed "s|:$_entry||g")"
    eval "$_var=$_value"

    case "$_position" in
        pre)
            eval "$_var=$_entry:$_value"
            ;;
        post)
            eval "$_var=$_value:$_entry"
            ;;
        *)
            ;;
    esac
    unset _position _entry _value

    # shellcheck disable=SC2163
    export "$_var"
    unset _var
}

# Wrapper helpers -------------------------------------------------------------

complete_alias() {
    case "$SHELL_CMD" in
        bash)
            # shellcheck disable=SC2039
            _prior_complete="$(command complete -p 2>/dev/null | command grep " $2$")"
            [ $? -eq 0 ] || return
            eval "$(printf %s "$_prior_complete" | sed "s/ $2\$//") '$1'"
            ;;
        zsh | -zsh)
            if [ "$(whence -w "_$2" | cut -d ' ' -f 2)" = 'function' ]; then
                compdef "_$2" "$1"="$2"
            fi
            ;;
        *) return 1
    esac
}

unalias_if_exists() {
    alias "$1" >/dev/null 2>&1 && unalias "$1"
}
