# Shell runtime configuration | terminal setup


[[ $- == *i* ]] || return
# interactive shell -----------------------------------------------------------


# shell attributes
set -o vi


# disable interpretation of Ctrl+S as ScrollLock
stty -ixon


term_256color="$COLORTERM""$XTERM_VERSION""$ROXTERM_ID""$KONSOLE_DBUS_SESSION"
SEND_256_COLORS_TO_REMOTE=1
if [[ -n "$term_256color" ]] || [[ -n "$SEND_256_COLORS_TO_REMOTE" ]]; then
    case "$TERM" in
      'xterm')
        if [[ -n "$XTERM_VERSION" ]]; then
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
        elif [[ -n "$KONSOLE_DBUS_SESSION" ]]; then
            TERM='konsole-256color'
        elif [[ "$COLORTERM" == 'gnome-terminal' ]]; then
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
    export TERM

    if [[ -n "$TERMCAP" ]] && [[ "$TERM" == 'screen-256color' ]]; then
        export TERMCAP=$(echo "$TERMCAP" | sed -e 's/Co#8/Co#256/g')
    fi
fi
unset term_256color

# TERM fallbacks for missing terminfo files
SCREEN_COLORS=$(tput colors 2> /dev/null)
if [[ -z "$SCREEN_COLORS" ]]; then
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
    export TERM
    SCREEN_COLORS=$(tput colors 2> /dev/null)
fi
if [[ -z "$SCREEN_COLORS" ]]; then
    case "$TERM" in
      gnome*|xterm*|konsole*|aterm|[Ee]term)
        export TERM='xterm'
        ;;
      rxvt*)
        export TERM='rxvt'
        ;;
      screen*)
        export TERM='screen'
        ;;
    esac
    SCREEN_COLORS=$(tput colors 2> /dev/null)
fi
export SCREEN_COLORS

export CLICOLOR=1

export LSCOLORS=GxFxCxDxBxegedabagaced
