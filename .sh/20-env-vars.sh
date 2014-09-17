# Shell runtime configuration | environment variables

function libpathmunge
{
    [[ ! -d "$1" ]] && return

    LD_LIBRARY_PATH="$(echo ${LD_LIBRARY_PATH#$1:} | sed "s|:$1||g")"

    case "$2" in
      'after')
        LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$1"
        ;;
      'before')
        LD_LIBRARY_PATH="$1:$LD_LIBRARY_PATH"
        ;;
    esac

    export LD_LIBRARY_PATH
}

function pathmunge
{
    [[ ! -d "$1" ]] && return

    PATH="$(echo ${PATH#$1:} | sed "s|:$1||g")"

    case "$2" in
      'after')
        PATH="$PATH:$1"
        ;;
      'before')
        PATH="$1:$PATH"
        ;;
    esac

    export PATH
}


# shell

export HISTCONTROL=ignoredups
export HISTSIZE=1000000
export HISTFILESIZE=1000000

libpathmunge /usr/local/lib before
pathmunge /usr/local/sbin before
pathmunge /usr/local/bin before

# Homebrew
BREW_PREFIX="$(which brew &> /dev/null && brew --prefix)"
if [[ -d "$BREW_PREFIX" ]]; then
    [[ -f "$HOME"/.brew-github-token ]] \
     && export HOMEBREW_GITHUB_API_TOKEN="$(cat "$HOME"/.brew-github-token)"

    pathmunge "$BREW_PREFIX"/bin before
    pathmunge "$BREW_PREFIX"/opt/coreutils/libexec/gnubin before
    pathmunge "$BREW_PREFIX"/opt/ruby/bin before

    [[ -f "$BREW_PREFIX"/opt/curl-ca-bundle/share/ca-bundle.crt ]] \
     && export SSL_CERT_FILE="$BREW_PREFIX"/opt/curl-ca-bundle/share/ca-bundle.crt
fi

# MacPorts
if [[ -d /opt/local ]]; then
    pathmunge /opt/local/sbin before
    pathmunge /opt/local/bin before
    pathmunge \
        /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin \
        before
    pathmunge /opt/local/libexec/gnubin before
fi

pathmunge "$HOME"/bin before

# preferred applications
export EDITOR=/usr/bin/vim
export SVN_EDITOR=/usr/bin/vim
