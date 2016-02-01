#!/bin/sh
# Shell runtime configuration | SSH agent

# on Mac, use OS X Keychain
[ "$(uname -s)" = 'Darwin' ] && return

export SSH_ENV="$HOME/.ssh/env"

_ssh_agent_start() {
    ssh_dir="$(dirname "$SSH_ENV")"
    if [ ! -d "$ssh_dir" ]; then
        if [ ! -e "$ssh_dir" ]; then
            mkdir -p -m 0700 "$ssh_dir"
        else
            echo "error: cannot start SSH agent: '$ssh_dir' is not a directory" >&2
            return
        fi
    fi

    ssh-agent -s | command -v grep -v '^echo' > "$SSH_ENV"
    chmod 0600 "$SSH_ENV"

    # shellcheck disable=SC1090
    . "$SSH_ENV" > /dev/null
}

if [ -e "$SSH_AUTH_SOCK" ] \
    && [ -n "$SSH_AGENT_PID" ] \
    && pgrep ssh-agent | cut -d ' ' -f 1 | grep -q "^$SSH_AGENT_PID$"; then
    # SSH agent was initialized elsewhere and was set up in this shell's env

    if [ -t 0 ]; then
        # interactive shell

        if ! ssh-add -l >& /dev/null; then
            # SSH agent has no keys

            ssh-add
        fi
    fi

elif [ -f "$SSH_ENV" ]; then
    # SSH agent was initialized by this script (or equivalent)

    # shellcheck disable=SC1090
    . "$SSH_ENV" > /dev/null

    if ! [ -e "$SSH_AUTH_SOCK" ] \
        && [ -n "$SSH_AGENT_PID" ] && (pgrep ssh-agent | grep -q "^$SSH_AGENT_PID$"); then
        # SSH agent died

        unset SSH_AUTH_SOCK SSH_AGENT_PID

        if [ -t 0 ]; then
            # interactive shell

            _ssh_agent_start
            ssh-add
        fi
    fi

else
    # SSH agent was not initialized

    if [ -t 0 ]; then
        # interactive shell

        _ssh_agent_start
        ssh-add
    fi
fi

unset _ssh_agent_start
