# Shell runtime configuration | SSH agent


export SSH_ENV="$HOME/.ssh/env"


function ssh_agent_add_keys
{
    ssh-add
}


function ssh_agent_start
{
    ssh_dir="$(dirname "$SSH_ENV")"
    if [[ ! -d "$ssh_dir" ]]; then
        if [[ ! -e "$ssh_dir" ]]; then
            mkdir -p -m 0700 "$ssh_dir"
        else
            echo "cannot start SSH agent: '$ssh_dir' is not a directory" >&2
            return
        fi
    fi

    ssh-agent -s | "$GREP" -v '^echo' > "$SSH_ENV"
    chmod 0600 "$SSH_ENV"

    . "$SSH_ENV" > /dev/null
}


if [[ -e "$SSH_AUTH_SOCK"
      && -n "$SSH_AGENT_PID"
      && -n "$(ps -fp "$SSH_AGENT_PID" | "$GREP" ssh-agent)" ]]; then
    # SSH agent was initialized elsewhere and was set up in this shell's env

    if [[ $- == *i* ]]; then
        # interactive shell

        if ! ssh-add -l >& /dev/null; then
            # SSH agent has no keys

            ssh_agent_add_keys
        fi
    fi

elif [[ -f "$SSH_ENV" ]]; then
    # SSH agent was initialized by this script (or equivalent)

    . "$SSH_ENV" > /dev/null

    if ! [[ -e "$SSH_AUTH_SOCK"
            && -n "$SSH_AGENT_PID"
            && -n "$(ps -fp "$SSH_AGENT_PID" | "$GREP" ssh-agent)" ]]; then
        # SSH agent died

        unset SSH_AUTH_SOCK
        unset SSH_AGENT_PID

        if [[ $- == *i* ]]; then
            # interactive shell

            ssh_agent_start
            ssh_agent_add_keys
        fi
    fi

else
    # SSH agent was not initialized

    if [[ $- == *i* ]]; then
        # interactive shell

        ssh_agent_start
        ssh_agent_add_keys
    fi
fi

unset ssh_agent_add_keys
unset ssh_agent_start
