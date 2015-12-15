#!/bin/sh
# Shell runtime configuration | path variables

# Helpers ---------------------------------------------------------------------

dylib_path_affix() {
    affix_to_path_var DYLD_LIBRARY_PATH "$@"
}

lib_path_affix() {
    affix_to_path_var LD_LIBRARY_PATH "$@"
}

path_affix() {
    affix_to_path_var PATH "$@"
}

# Paths -----------------------------------------------------------------------

lib_path_affix pre /usr/local/lib
path_affix pre /usr/local/sbin
path_affix pre /usr/local/bin

# Homebrew / Linuxbrew
BREW_PREFIX="$(which brew >/dev/null && brew --prefix)"
if [ -d "$BREW_PREFIX" ]; then
    path_affix pre "$BREW_PREFIX"/bin
    path_affix pre "$BREW_PREFIX"/opt/coreutils/libexec/gnubin
    path_affix pre "$BREW_PREFIX"/opt/gnu-sed/libexec/gnubin
    path_affix pre "$BREW_PREFIX"/opt/gnu-tar/libexec/gnubin
    path_affix pre "$BREW_PREFIX"/opt/ruby/bin
fi

# MacPorts
if [ -d /opt/local ]; then
    path_affix pre /opt/local/sbin
    path_affix pre /opt/local/bin
    path_affix pre /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin
    path_affix pre /opt/local/libexec/gnubin
fi

path_affix post "$HOME"/Library/Android/sdk/platform-tools

path_affix pre "$HOME"/bin
