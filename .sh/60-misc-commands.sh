# shellcheck shell=sh
# Shell configuration | miscellaneous commands

# Install The Fuck as fx
which thefuck >/dev/null 2>&1 && eval "$(thefuck --alias fx)"

shellcheck() {
    _shell_=''

    _expect_arg_arg_=
    for _arg_ in "$@"; do
        [ "$_arg_" = '--' ] && break

        case "$_arg_" in
            --) break ;;
            -e|--exclude|-f|--format|-C|--color|-s|--shell)
                _expect_arg_arg_=true
                ;;
            --*=*|--external-sources|--version) continue ;;
            -C*|-x|-V) continue ;;
            -*) continue ;;
            *)
                if [ "$_expect_arg_arg_" ]; then
                    _expect_arg_arg_=
                    continue
                fi

                [ ! -f "$_arg_" ] && continue

                _line_="$(head -1 "$_arg_")"
                if expr "$_line_" : '#!.*[/[:blank:]]\(sh\|dash\|bash\|ksh\)' \
                        1>/dev/null; then
                    unset _line_
                    break
                fi
                unset _line_

                case "$_arg_" in
                    *.ksh) _shell_='ksh' ;;
                    *.dash) _shell_='dash' ;;
                    *.bash|*.zsh) _shell_='bash' ;;
                esac

                break
        esac
    done
    unset _arg_ _expect_arg_arg_

    if [ -n "$_shell_" ]; then
        command shellcheck --shell "$_shell_" "$@"
    else
        command shellcheck "$@"
    fi
    _ret_=$?
    unset _shell_
    return $_ret_
}
