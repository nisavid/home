# shellcheck shell=sh
# Shell configuration | development

# Environment variables -------------------------------------------------------

export ANSIBLE_HOSTS='/usr/local/bin/ansible-ec2'
export EC2_HOME='/usr/local/ec2'
path_affix pre "$EC2_HOME/bin"
export MYSQL_PS1="\u@\h \d> "

# Python environment ----------------------------------------------------------

PYENVS="$(printf \
    '%s:%s:%s:%s:%s' \
    "$HOME"/.pyenv/devel \
    "$HOME"/.pyenv/prod \
    "$HOME"/.pyenv/py2devel \
    "$HOME"/.pyenv/py2prod \
    "$PYENVS")"

# Ruby environment ------------------------------------------------------------

export RAILS_ENV='development'
export RI='--format ansi'
export RIPDIR='/home/nisavid/.rip'
export RUBYDB_OPTS="HOST=localhost PORT=9000"
export RUBYLIB="$RUBYLIB:$RIPDIR/active/lib"
path_affix post "$RIPDIR/active/bin"

RUBYDB_LIBS="$(printf \
    '%s:%s' \
    '/Applications/Komodo IDE 10.app/Contents/SharedSupport/dbgp/rubylib/rdbgp.rb' \
    "$RUBYDB_LIBS")"

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

unalias_if_exists rs

# Developer tools -------------------------------------------------------------

unalias_if_exists be
be() {
    bundle exec "$@"
}

unalias_if_exists bi
bi() {
    bundle install "$@"
}

unalias_if_exists bu
bu() {
    bundle update "$@"
}

unalias_if_exists g
g() {
    git "$@"
}
complete_alias g git

git_web_open() {
    _remotes_info="$(git remote --verbose show)" || return
    _uri="$(\
        printf %s "$_remotes_info" \
        | grep '^origin	' | head -1 | cut -f2 | cut -d' ' -f1)"
    if ! printf %s "$_uri" | grep -q '^http\(s\)\?://'; then
        echo origin remote URI is not an HTTP URI: "$_uri" >&2
        return 1
    fi

    if printf %s "$_uri" | grep -q '^http\(s\)\?://\([^/]\+\.\)\?github\.com/'; then
        if _current_ref="$(git describe --all 2>/dev/null)"; then
            if printf %s "$_current_ref" | grep -q '^\(heads\|tags\)/.\+'; then
                _current_shortref="$(\
                    printf %s "$_current_ref" | sed 's%^\(heads\|tags\)/%%')"
                _uri="$_uri/tree/$_current_shortref"
            fi
        fi
    fi

    app_open "$_uri"

    unset _current_ref _current_shortref _remotes_info _uri
}

gwo() {
    git_web_open "$@"
}

unalias_if_exists my
my() {
    mysql "$@"
}
complete_alias my mysql

unalias_if_exists mye
mye() {
    my -e "$@"
}
complete_alias my mysql

my_last_fk_error() {
    # shellcheck disable=SC2059
    printf "$(mysql -e 'SHOW ENGINE INNODB STATUS')" \
        | sed -ne '/^LATEST FOREIGN KEY ERROR$/,/^----/{/ERROR/{n;n};/----/{q};p}'
}

unalias_if_exists npm
npm() {
    node --max-old-space-size=4000 /usr/local/bin/npm "$@"
}

unalias_if_exists pryr
pryr() {
    RUBYOPT=-rpry-rescue/peek/quit "$@"
}

unalias_if_exists pup
pup() {
    command pup --color "$@"
}

unalias_if_exists pyvenv
pyvenv() {
    python3 -m venv "$@"
}
complete_alias pyvenv python3

unalias_if_exists rspec
rspec() {
    re_t command rspec "$@"
}

unalias_if_exists rsp
rsp() {
    rspec "$@"
}
complete_alias rsp rspec

unalias_if_exists ru

alias dr=tldr

alias drup='tldr --update'

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

unalias_if_exists vq
vq() {
    _tmpdir="$(mktemp -d -t vg.XXXXXXXX)"
    _pipe="$_tmpdir"/pipe
    mkfifo "$_pipe"
    cat <&0 >"$_pipe" &
    vim -q "$_pipe"
    unset _tmpdir _pipe
}
complete_alias vq vim

unalias_if_exists vsl
vsl() {
    vim +SessionList +only
}

unalias_if_exists vso
vso() {
    if [ $# -lt 1 ]; then
        vsl
        return
    fi

    vim "+SessionOpen $1" "+let &titlestring = 'vso $1'" "+set title"
}

unalias_if_exists z
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

pkill_zeus() {
  pkill -f '^([^ ]*/)?zeus'
}

# Python
alias ipy='ipython'

# Python environment
alias pyad='. "$HOME"/.pyenv/devel/bin/activate'
alias pyad2='. "$HOME"/.pyenv/py2devel/bin/activate'
alias pyap='. "$HOME"/.pyenv/prod/bin/activate'
alias pyap2='. "$HOME"/.pyenv/py2prod/bin/activate'
alias pyd='deactivate'

# systems administration
alias pipd='"$HOME"/.pyenv/devel/bin/pip'
alias pipp='"$HOME"/.pyenv/prod/bin/pip'

# project administration
alias makepyd='make PYENV="$HOME"/.pyenv/devel'
alias makepyp='make PYENV="$HOME"/.pyenv/prod'
