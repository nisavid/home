#!/bin/sh
# Shell runtime configuration | utilities

# Fallbacks for standard utilities --------------------------------------------

if ! command -v realpath >/dev/null 2>&1; then
    # assume that readlink, if present, is non-GNU

    # mostly-POSIX shell implementation of mostly-GNU readlink(1) and realpath(1)
    # this is heavily based on the implementation by Geoff Nixon found at
    # https://gist.github.com/geoff-codes/1f23957288d371b75a2e
    readlink() {
        local readlink_exists=1
        local assert_dirs_exist=1
        local entry_sep
        entry_sep="$(printf \\n)"

        readlink_usage() {
            echo "usage: $(basename "$0") [-efmnqsvz] [file ...]" >&2
        }

        OPTIND=1
        while getopts 'efhmnqsvz?' opt; do
            case "$opt" in
                e) readlink_realpath=1; assert_dirs_exist=1; readlink_exists=1 ;;
                f) readlink_realpath=1; assert_dirs_exist=1; readlink_exists='' ;;
                h) readlink_usage; exit 0 ;;
                m) readlink_realpath=1; assert_dirs_exist='' ; readlink_exists='' ;;
                n) ;;
                q|s) readlink_verbose=0 ;;
                v) readlink_verbose=1 ;;
                z) entry_sep="$(printf \\0)" ;;
                \?) readlink_usage; exit 1 ;;
            esac
        done
        shift $((OPTIND - 1))

        readlink_readlink() {
            local readlink_readlink
            readlink_readlink="$(command ls -ld "$@" | sed 's|.* -> ||')"

            [ "$readlink_realpath" ] \
                && [ "$(printf %s "$readlink_readlink" | cut -c1)" != / ] \
                && readlink_readlink="$(pwd -P)/$readlink_readlink"

            printf %s "$readlink_readlink"
        }

        readlink_canonicalize() {
            local readlink_canon readlink_canonical
            [ "$(basename "$@")" = . ] || [ "$(basename "$@")" = .. ] \
                && readlink_canon="$(cd "$(pwd -P)/$(basename "$@")"; pwd -P)" \
                || readlink_canon="$(pwd -P)/$(basename "$@")"
            readlink_canonical="$(printf %s "$readlink_canon" | sed 's|//|/|g')"

            printf %s "$readlink_canonical"
        }

        readlink_no_dir() {
            if [ ! "$assert_dirs_exist" ]; then
                printf %s "$1$entry_sep"
                return 0
            fi

            [ "$readlink_verbose" ] && echo "Directory $(dirname "$@") doesn't exist." >&2

            return 1
        }

        readlink_no_target() {
            if [ ! "$readlink_exists" ]; then
                printf %s "$(readlink_canonicalize "$@")$entry_sep"
                return 0
            fi

            [ "$readlink_verbose" ] && echo "$*: No such file or directory." >&2

            return 1
        }

        readlink_not_link() {
            if [ ! "$readlink_realpath" ]; then
                [ "$readlink_verbose" ] && echo "$* is not a link." >&2 && return 1
                return 1
            fi

            if [ "$readlink_realpath" ]; then
                local readlink_canonical
                readlink_canonical="$(readlink_canonicalize "$@")"
                printf %s "$readlink_canonical$entry_sep"
                return 0
            fi

            if [ "$readlink_verbose" ]; then
                local readlink_file_type
                [ -f "$@" ] && readlink_file_type="regular file" \
                    || [ -d "$@" ] && readlink_file_type="directory" \
                    || [ -p "$@" ] && readlink_file_type="FIFO" \
                    || [ -b "$@" ] && readlink_file_type="block special file" \
                    || [ -c "$@" ] && readlink_file_type="character special file" \
                    || [ -S "$@" ] && readlink_file_type="socket"
                echo "$(basename "$0"): $*: is a $readlink_file_type." >&2; return 1
            fi
        }

        readlink_try() {
            local readlink_cur_dir readlink_cur_base readlink_readlink
            readlink_cur_dir="$(dirname "$@")"
            readlink_cur_base="$(basename "$@")"

            cd "$readlink_cur_dir" 2>/dev/null || readlink_no_dir "$@"
            [ -e "$readlink_cur_base" ] || readlink_no_target "$(pwd -P)/$*"
            [ -L "$readlink_cur_base" ] || readlink_not_link "$@"

            readlink_readlink="$(readlink_readlink "$readlink_cur_base")"

            if [ -z "$readlink_realpath" ]; then
                printf %s "$readlink_readlink$entry_sep"
                exit 0
            else
                readlink_try "$readlink_readlink"
            fi
        }

        for readlink_target; do :; done
        [ -z "$readlink_target" ] && readlink_usage && exit 1
        readlink_try "$readlink_target"
    }

    if ! which realpath >/dev/null 2>&1; then
        realpath() {
            printf %s "$1" | command grep -q '^/' \
                && printf %s "$1" \
                || printf %s "$(pwd -P)/${1#./}"
        }
    fi
fi

# Functions -------------------------------------------------------------------

affix_to_path_var() {
    local var="$1"
    local position="$2"
    local entry="$3"

    [ ! -d "$entry" ] && return

    local value_prev
    value_prev="$(eval printf %s \$"$var")"

    # strip entry from beginning, middle, and end
    eval "$var=$(printf %s "${${value_prev}#${entry}:}" | sed "s|:$entry||g")"

    case "$position" in
        pre)
            eval "$var=$entry:$value_prev"
            ;;
        post)
            eval "$var=$value_prev:$entry"
            ;;
        *)
            ;;
    esac

    # shellcheck disable=SC2163
    export "$var"
}

in_dir() {
    cd "$1" || return
    shift

    "$@"
    local ret=$?

    cd - > /dev/null || return

    return $ret
}

# Aliases ---------------------------------------------------------------------

alias shrc='source "$HOME"/.shrc'
