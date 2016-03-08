#!/bin/sh
# Shell configuration | development

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

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# Developer tools -------------------------------------------------------------

be() {
    bundle exec "$@"
}

bi() {
    bundle install "$@"
}

# FIXME: make wrappers work with completion and subshells
#unalias g
#g() {
#    git "$@"
#}

my() {
    mysql "$@"
}

pryr() {
    RUBYOPT=-rpry-rescue/peek/quit "$@"
}

rspec() {
    re_t command rspec "$@"
}

# FIXME: make wrappers work with completion and subshells
alias v='vim -p'
#unalias v
#v() {
#    vim -p "$@"
#}

# FIXME: make wrappers work with completion and subshells
alias vi=vim
#vi() {
#    vim "$@"
#}

vq() {
    _tmpdir="$(mktemp -d -t vg.XXXXXXXX)"
    _pipe="$_tmpdir"/pipe
    mkfifo "$_pipe"
    cat <&0 >"$_pipe" &
    vim -q "$_pipe"
    unset _tmpdir _pipe
}

vsl() {
    vim +SessionList +only
}

zgm() {
    no_re zeus generate migration
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
