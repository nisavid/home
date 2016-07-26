#!/bin/sh
# Shell configuration | development

# Environment variables -------------------------------------------------------

export ANSIBLE_HOSTS='/usr/local/bin/ansible-ec2'
export EC2_HOME='/usr/local/ec2'
path_affix pre "$EC2_HOME/bin"
export MYSQL_PS1="\u@\h \d> "
export RAILS_ENV='development'
export RI='--format ansi'
export RIPDIR='/home/nisavid/.rip'
export RUBYLIB="$RUBYLIB:$RIPDIR/active/lib"
path_affix post "$RIPDIR/active/bin"

PYENVS="$(printf \
    '%s:%s:%s:%s:%s' \
    "$HOME"/.pyenv/devel \
    "$HOME"/.pyenv/prod \
    "$HOME"/.pyenv/py2devel \
    "$HOME"/.pyenv/py2prod \
    "$PYENVS")"

# Shell option helpers --------------------------------------------------------

using_ksh_arrays() {
    # Zsh: ensure that array indices start at 0
    if [ "$SHELL_CMD_NAME" = 'zsh' ]; then
        _ksharrays_prev_="$(setopt | command grep '^ksharrays$')"
        setopt ksh_arrays
    fi

    "$@" || _ret_=$?

    if [ "$SHELL_CMD_NAME" = 'zsh' ] && [ ! "$_ksharrays_prev_" ]; then
        setopt no_ksh_arrays
    fi

    unset _ksharrays_prev_
    return $_ret_
}

# Environment variable helpers ------------------------------------------------

no_re() {
    RAILS_ENV='' "$@"
}

re_d() {
    RAILS_ENV=development "$@"
}

re_p() {
    RAILS_ENV=production "$@"
}

re_t() {
    # shellcheck disable=SC2037
    RAILS_ENV=test "$@"
}

# Path helpers ----------------------------------------------------------------

cmd_path() {
    command command -v "$@"
}

rvm_env_cmd_path() {
    _env_="$1"
    shift

    rvm "$_env_" 'do' command -v "$@"

    ret=$?
    unset _env_
    return $ret
}

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# Developer tools -------------------------------------------------------------

be() {
    bundle exec "$@"
}

bi() {
    bundle install "$@"
}

bu() {
    bundle update "$@"
}

unalias_if_exists g
g() {
    git "$@"
}
complete_alias g git

my() {
    mysql "$@"
}

unalias_if_exists npm
npm() {
    node --max-old-space-size=4000 /usr/local/bin/npm "$@"
}

pryr() {
    RUBYOPT=-rpry-rescue/peek/quit "$@"
}

rspec() {
    re_t command rspec "$@"
}

unalias_if_exists ru

unalias_if_exists v
v() {
    vim -p "$@"
}
complete_alias v vim

unalias_if_exists vi
vi() {
    vim "$@"
}
complete_alias vi vim

vq() {
    _tmpdir="$(mktemp -d -t vg.XXXXXXXX)"
    _pipe="$_tmpdir"/pipe
    mkfifo "$_pipe"
    cat <&0 >"$_pipe" &
    vim -q "$_pipe"
    unset _tmpdir _pipe
}
complete_alias vq vim

vso() {
    if [ $# -lt 1 ]; then
        vsl
        return
    fi

    vim "+SessionOpen $1" "+let &titlestring = 'vso $1'" "+set title"
}

vsl() {
    vim +SessionList +only
}

z() {
    if [ $# -lt 1 ]; then
        no_re zeus
    fi

    case "$1" in
        dbm)
            shift
            no_re zeus rake db:migrate "$@"
            ;;
        dbmd)
            shift
            no_re zeus rake db:migrate:down "$@"
            ;;
        dbms)
            shift
            no_re zeus rake db:migrate:status "$@"
            ;;
        dbmu)
            shift
            no_re zeus rake db:migrate:up "$@"
            ;;
        gm)
            shift
            no_re zeus generate migration "$@"
            ;;
        rk)
            shift
            no_re zeus rake "$@"
            ;;
        st)
            shift
            zeus start "$@"
            ;;
        *)
            no_re zeus "$@"
            ;;
    esac
}

# Python
alias ipy='ipython'

# Python environment
alias pyad='. "$HOME"/.pyenv/devel/bin/activate'
alias pyad2='. "$HOME"/.pyenv/py2devel/bin/activate'
alias pyap='. "$HOME"/.pyenv/prod/bin/activate'
alias pyap2='. "$HOME"/.pyenv/py2prod/bin/activate'

# systems administration
alias pipd='"$HOME"/.pyenv/devel/bin/pip'
alias pipp='"$HOME"/.pyenv/devel/bin/pip'

# project administration
alias makepyd='make PYENV="$HOME"/.pyenv/devel'
alias makepyp='make PYENV="$HOME"/.pyenv/prod'
