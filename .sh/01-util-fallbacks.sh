# shellcheck shell=sh
# Shell configuration | fallbacks for standard utilities

if ! command -v realpath >/dev/null 2>&1; then
    # assume that readlink, if present, is non-GNU

    # mostly-POSIX shell implementation of mostly-GNU readlink(1) and realpath(1)
    # this is heavily based on the implementation by Geoff Nixon found at
    # https://gist.github.com/geoff-codes/1f23957288d371b75a2e
    readlink() {
        _readlink_exists=1
        _assert_dirs_exist=1
        _entry_sep="$(printf \\n)"

        _readlink_usage() {
            echo "usage: $(basename "$0") [-efmnqsvz] [file ...]" >&2
        }

        OPTIND=1
        while getopts 'efhmnqsvz?' opt; do
            case "$opt" in
                e) readlink_realpath=1; _assert_dirs_exist=1; _readlink_exists=1 ;;
                f) readlink_realpath=1; _assert_dirs_exist=1; _readlink_exists='' ;;
                h) _readlink_usage; exit 0 ;;
                m) readlink_realpath=1; _assert_dirs_exist='' ; _readlink_exists='' ;;
                n) ;;
                q|s) readlink_verbose=0 ;;
                v) readlink_verbose=1 ;;
                z) _entry_sep="$(printf \\0)" ;;
                \?) _readlink_usage; exit 1 ;;
            esac
        done
        shift $((OPTIND - 1))

        _readlink_readlink() {
            _readlink_readlink="$(command ls -ld "$@" | sed 's|.* -> ||')"

            [ "$readlink_realpath" ] \
                && [ "$(printf %s "$_readlink_readlink" | cut -c1)" != / ] \
                && _readlink_readlink="$(pwd -P)/$_readlink_readlink"

            printf %s "$_readlink_readlink"
        }

        readlink_canonicalize() {
            [ "$(basename "$@")" = . ] || [ "$(basename "$@")" = .. ] \
                && _readlink_canon="$(cd "$(pwd -P)/$(basename "$@")"; pwd -P)" \
                || _readlink_canon="$(pwd -P)/$(basename "$@")"
            _readlink_canonical="$(printf %s "$_readlink_canon" | sed 's|//|/|g')"

            printf %s "$_readlink_canonical"
        }

        readlink_no_dir() {
            if [ ! "$_assert_dirs_exist" ]; then
                printf %s "$1$_entry_sep"
                return 0
            fi

            [ "$readlink_verbose" ] && echo "Directory $(dirname "$@") doesn't exist." >&2

            return 1
        }

        readlink_no_target() {
            if [ ! "$_readlink_exists" ]; then
                printf %s "$(readlink_canonicalize "$@")$_entry_sep"
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
                _readlink_canonical="$(readlink_canonicalize "$@")"
                printf %s "$_readlink_canonical$_entry_sep"
                return 0
            fi

            if [ "$readlink_verbose" ]; then
                [ -f "$@" ] && _readlink_file_type="regular file" \
                    || [ -d "$@" ] && _readlink_file_type="directory" \
                    || [ -p "$@" ] && _readlink_file_type="FIFO" \
                    || [ -b "$@" ] && _readlink_file_type="block special file" \
                    || [ -c "$@" ] && _readlink_file_type="character special file" \
                    || [ -S "$@" ] && _readlink_file_type="socket"
                echo "$(basename "$0"): $*: is a ${_readlink_file_type}." >&2; return 1
            fi
        }

        _readlink_try() {
            _readlink_cur_dir="$(dirname "$@")"
            _readlink_cur_base="$(basename "$@")"

            cd "$_readlink_cur_dir" 2>/dev/null || readlink_no_dir "$@"
            [ -e "$_readlink_cur_base" ] || readlink_no_target "$(pwd -P)/$*"
            [ -L "$_readlink_cur_base" ] || readlink_not_link "$@"

            _readlink_readlink="$(_readlink_readlink "$_readlink_cur_base")"

            if [ -z "$readlink_realpath" ]; then
                printf %s "$_readlink_readlink$_entry_sep"
                exit 0
            else
                _readlink_try "$_readlink_readlink"
            fi
        }

        for _readlink_target; do :; done
        [ -z "$_readlink_target" ] && _readlink_usage && exit 1
        _readlink_try "$_readlink_target"

        unset _readlink_exists _assert_dirs_exist _entry_sep _readlink_usage \
            _readlink_readlink _readlink_canon _readlink_canonical _readlink_file_type \
            _readlink_try _readlink_cur_dir _readlink_cur_base _readlink_target
    }

    if ! which realpath >/dev/null 2>&1; then
        realpath() {
            printf %s "$1" | command grep -q '^/' \
                && printf %s "$1" \
                || printf %s "$(pwd -P)/${1#./}"
        }
    fi
fi
