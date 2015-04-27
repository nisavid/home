# Shell runtime configuration | environment variables

# Helpers ---------------------------------------------------------------------

function dylib_path_affix
{
    _path_affix_to_var LD_LIBRARY_PATH $@
}

function lib_path_affix
{
    _path_affix_to_var LD_LIBRARY_PATH $@
}

function path_affix
{
    _path_affix_to_var PATH $@
}

function _path_affix_to_var
{
    local var="$1"
    local position="$2"
    local entry="$3"

    [[ ! -d "$entry" ]] && return

    case "$SHELL_NAME" in
      'Bash')
        local value_prev="${!var}"

        declare $var="$(echo ${value_prev#$entry:} | sed "s|:$entry||g")"

        case "$position" in
          'pre')
            declare $var="$entry:$value_prev"
            ;;
          'post')
            declare $var="$entry:$value_prev"
            ;;
          *)
            # FIXME: complain
            return
            ;;
        esac
        ;;
      'Zsh')
        local value_prev="${(P)var}"

        : ${(P)var::="$(echo ${value_prev#$entry:} | sed "s|:$entry||g")"}

        case "$position" in
          'pre')
            : ${(P)var::="$entry:$value_prev"}
            ;;
          'post')
            : ${(P)var::="$value_prev:$entry"}
            ;;
          *)
            # FIXME: complain
            return
            ;;
        esac
        ;;
      *)
        # FIXME: complain
        return
        ;;
    esac

    export $var
}


# Shell -----------------------------------------------------------------------

export HISTCONTROL=ignoredups
export HISTSIZE=1000000
export HISTFILESIZE=1000000


# Paths -----------------------------------------------------------------------

lib_path_affix pre /usr/local/lib
path_affix pre /usr/local/sbin
path_affix pre /usr/local/bin

# Homebrew
BREW_PREFIX="$(which brew &> /dev/null && brew --prefix)"
if [[ -d "$BREW_PREFIX" ]]; then
    [[ -f "$HOME"/.brew-github-token ]] \
      && export HOMEBREW_GITHUB_API_TOKEN="$(cat "$HOME"/.brew-github-token)"

    path_affix pre "$BREW_PREFIX"/bin
    path_affix pre "$BREW_PREFIX"/opt/coreutils/libexec/gnubin
    path_affix pre "$BREW_PREFIX"/opt/gnu-sed/libexec/gnubin
    path_affix pre "$BREW_PREFIX"/opt/ruby/bin

    [[ -f "$BREW_PREFIX"/opt/curl-ca-bundle/share/ca-bundle.crt ]] \
      && export SSL_CERT_FILE="$BREW_PREFIX"/opt/curl-ca-bundle/share/ca-bundle.crt
fi

# MacPorts
if [[ -d /opt/local ]]; then
    path_affix pre /opt/local/sbin
    path_affix pre /opt/local/bin
    path_affix pre \
               /opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin
    path_affix pre /opt/local/libexec/gnubin
fi

path_affix post "$HOME"/Library/Android/sdk/platform-tools

path_affix pre "$HOME"/bin


# Preferred applications ------------------------------------------------------

export EDITOR="$(which vim)"
export SVN_EDITOR="$EDITOR"
