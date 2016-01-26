#!/bin/sh
# Shell runtime configuration | development

# Environment variables -------------------------------------------------------

export ANSIBLE_HOSTS='/usr/local/bin/ansible-ec2'
export EC2_HOME='/usr/local/ec2'
path_affix pre "$EC2_HOME/bin"
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

my() {
    mysql "$@"
}

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

redis_purge() {
    redis-cli KEYS '*' | sed 's/.*/"&"/' | xargs redis-cli DEL
}

zgm() {
    no_re zeus generate migration
}

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# Developer tools -------------------------------------------------------------

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
