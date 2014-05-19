# Bash runtime configuration | development


# ensure interactive shell
[[ $- != *i* ]] && return


# aliases

# Python environment
alias ad='. "$HOME"/pyenv/devel/bin/activate'
alias ad3='. "$HOME"/pyenv/py3devel/bin/activate'
alias ap='. "$HOME"/pyenv/prod/bin/activate'
alias ap3='. "$HOME"/pyenv/py3prod/bin/activate'

# systems administration
alias pipd='"$HOME"/pyenv/devel/bin/pip'
alias pipp='"$HOME"/pyenv/devel/bin/pip'

# project administration
alias maked='make PYENV="$HOME"/pyenv/devel'
alias makep='make PYENV="$HOME"/pyenv/prod'


# environment variables
export ANSIBLE_HOSTS=/usr/local/bin/ansible-ec2
export EC2_HOME=/usr/local/ec2
export JAVA_HOME="$(dirname $(dirname $(readlink -f /etc/alternatives/java)))"

pathmunge "$EC2_HOME/bin" before


# Python environment
PYENV_CANDIDATES=("$HOME"/pyenv/devel "$HOME"/pyenv/prod "$HOME"/pyenv/py3devel
                  "$HOME"/pyenv/py3prod ${PYENV_CANDIDATES[@]})
