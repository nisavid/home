# Bash runtime configuration | environment variables

function libpathmunge
{
    case ":$LD_LIBRARY_PATH:" in
        *:"$1":*)
            ;;
        "$1":*)
            ;;
        *:"$1")
            ;;
        *)
            if [[ "$2" == 'after' ]]; then
                export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$1"
            else
                export LD_LIBRARY_PATH="$1:$LD_LIBRARY_PATH"
            fi
    esac
}

function pathmunge
{
    [[ ! -d "$1" ]] && return

    export PATH="${PATH#$1:}"
    export PATH="$(echo $PATH | sed "s|:$1||g")"

    case "$2" in
        'after')
            export PATH="$PATH:$1"
            ;;
        'before')
            export PATH="$1:$PATH"
            ;;
    esac
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
