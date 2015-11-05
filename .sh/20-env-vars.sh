#!/bin/sh
# Shell runtime configuration | environment variables

# Shell -----------------------------------------------------------------------

export HISTCONTROL=ignoredups
export HISTSIZE=1000000
export HISTFILESIZE=1000000

# Homebrew / Linuxbrew --------------------------------------------------------

BREW_PREFIX="$(which brew >/dev/null && brew --prefix)"
if [ -d "$BREW_PREFIX" ]; then
    if [ -f "$HOME"/.brew-github-token ]; then
        HOMEBREW_GITHUB_API_TOKEN="$(cat "$HOME"/.brew-github-token)"
        export HOMEBREW_GITHUB_API_TOKEN
    fi

    [ -f "$BREW_PREFIX"/opt/curl-ca-bundle/share/ca-bundle.crt ] \
        && export SSL_CERT_FILE="$BREW_PREFIX"/opt/curl-ca-bundle/share/ca-bundle.crt
fi

# Preferred applications ------------------------------------------------------

EDITOR="$(command -v vim)"
export EDITOR
export SVN_EDITOR="$EDITOR"
