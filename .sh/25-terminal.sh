#!/bin/sh
# Shell configuration | terminal setup

[ -t 0 ] || return
# Interactive shell -----------------------------------------------------------

# shell attributes
set -o vi

# disable interpretation of Ctrl+S as ScrollLock
stty -ixon

term_256color="$COLORTERM""$XTERM_VERSION""$ROXTERM_ID""$KONSOLE_DBUS_SESSION"
SEND_256_COLORS_TO_REMOTE=1
if [ -n "$term_256color" ] || [ -n "$SEND_256_COLORS_TO_REMOTE" ]; then
    case "$TERM" in
        'xterm')
            if [ -n "$XTERM_VERSION" ]; then
                case "$XTERM_VERSION" in
                    'XTerm(256)')
                        TERM='xterm-256color'
                        ;;
                    'XTerm(88)')
                        TERM='xterm-88color'
                        ;;
                    'XTerm')
                        ;;
                esac
            elif [ -n "$KONSOLE_DBUS_SESSION" ]; then
                TERM='konsole-256color'
            elif [ "$COLORTERM" = 'gnome-terminal' ]; then
                TERM='gnome-256color'
            else
                TERM='xterm-256color'
            fi
            ;;
        'screen')
            TERM='screen-256color'
            ;;
        'Eterm')
            TERM='Eterm-256color'
            ;;
    esac

    if [ -n "$TERMCAP" ] && [ "$TERM" = 'screen-256color' ]; then
        TERMCAP="$(printf %s "$TERMCAP" | sed -e 's/Co#8/Co#256/g')"
        export TERMCAP
    fi
fi
unset term_256color

# TERM fallbacks for missing terminfo files
SCREEN_COLORS="$(tput colors 2> /dev/null)"
if [ -z "$SCREEN_COLORS" ]; then
    case "$TERM" in
        screen-*color-bce)
            TERM='screen-bce'
            ;;
        *-88color)
            TERM='xterm-88color'
            ;;
        *-256color)
            TERM='xterm-256color'
            ;;
    esac
    SCREEN_COLORS="$(tput colors 2> /dev/null)"
fi
if [ -z "$SCREEN_COLORS" ]; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            TERM='xterm'
            ;;
        rxvt*)
            TERM='rxvt'
            ;;
        screen*)
            TERM='screen'
            ;;
    esac
    SCREEN_COLORS="$(tput colors 2> /dev/null)"
fi

export TERM
export SCREEN_COLORS
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Completion ------------------------------------------------------------------

# load the system's shell completions
# NOTE:
#   this must be here, instead of in the shell-specific directories, so that the completions
#   can be referenced in downstream shell-agnostic settings, such as those that use
#   complete_alias
case "$SHELL_CMD" in
    bash)
        # shellcheck disable=SC2039
        if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
            # shellcheck disable=SC1091
            . /etc/bash_completion
        elif [ -f "$BREW_PREFIX"/etc/bash_completion ]; then
            # shellcheck disable=SC1090
            . "$BREW_PREFIX"/etc/bash_completion
        elif [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
            # shellcheck disable=SC1091
            . /opt/local/etc/profile.d/bash_completion.sh
        fi

        if [ -d "$BREW_PREFIX"/etc/bash_completion.d ]; then
            for _rc in "$BREW_PREFIX"/etc/bash_completion.d/*; do
                # shellcheck disable=SC1090
                . "$_rc"
            done
        fi
        ;;
    zsh | -zsh)
        autoload -Uz bashcompinit
        bashcompinit -i

        if [ -d "$BREW_PREFIX"/etc/bash_completion.d ]; then
            for _rc in "$BREW_PREFIX"/etc/bash_completion.d/*; do
                _basename="$(basename "$_rc" | sed 's/\.[^\.]\{1,\}//')"
                if [ -n "$(find "$BREW_PREFIX/share/zsh/site-functions" \
                                -name "$_basename.*")" ]; then
                    continue
                fi

                # shellcheck disable=SC1090
                . "$_rc" 2>/dev/null
            done
            unset _rc _basename
        fi
        ;;
esac
