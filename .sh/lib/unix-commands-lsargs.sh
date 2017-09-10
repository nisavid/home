# shellcheck shell=sh
# Shell configuration | Unix commands | ls args

unalias_if_exists ls
ls() {
    # shellcheck disable=2086
    eval command ls $LS_ARGS "$@"
}
