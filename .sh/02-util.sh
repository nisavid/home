# shellcheck shell=sh
# Shell configuration | utilities

# Shell configuration ---------------------------------------------------------

alias shrc='. "$HOME"/.shrc'

# Quoting ---------------------------------------------------------------------

quote() {
    printf %s "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/"
}

quote_all() {
    while [ $# -ne 0 ]; do
        quote "$1"
        shift
        [ $# -ne 0 ] && printf %s ' '
    done
}

# Directories -----------------------------------------------------------------

in_dir() {
    cd "$1" || return
    shift

    # FIXME:
    #   use this, but with proper quoting, to ensure that the following cd
    #   always works
    #eval "$@"
    "$@"
    _ret_=$?

    cd - >/dev/null || return

    return $_ret_
}

# Variable manipulation -------------------------------------------------------

affix_to_path_var() {
    _var_="$1"
    _position_="$2"
    _entry_="$3"

    [ ! -d "$_entry_" ] && { unset _var_ _position_ _entry_; return; }

    # strip entry from beginning, middle, and end
    _value_="$(eval "printf %s \$$_var_")"
    _value_="$(printf %s "${_value_#${_entry_}:}" | sed "s|:$_entry_||g")"
    eval "$_var_=$_value_"

    case "$_position_" in
        pre)
            eval "$_var_=$_entry_:$_value_"
            ;;
        post)
            eval "$_var_=$_value_:$_entry_"
            ;;
        *)
            ;;
    esac
    unset _position_ _entry_ _value_

    # shellcheck disable=SC2163
    export "$_var_"
    unset _var_
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
