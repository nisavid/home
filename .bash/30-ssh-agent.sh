# Bash runtime configuration | SSH agent


# ensure interactive shell
[[ $- != *i* ]] && return

# ensure non-SSH shell
[[ -n "$SSH_TTY" ]] && return


# ensure SSH agent

export SSH_ENV="$HOME/.ssh/env"

function ssh_add
{
    ssh-add
}

function start_ssh_agent
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

    ssh-agent -s | grep -v ^echo > "$SSH_ENV"
    chmod 0600 "$SSH_ENV"

    . "$SSH_ENV" > /dev/null

    trap 'ssh-agent -k' EXIT
}

if [[ -e "$SSH_AUTH_SOCK"
      && -n "$SSH_AGENT_PID"
      && -n "$(ps -fp "$SSH_AGENT_PID" | grep ssh-agent)" ]]; then
    # SSH agent was initialized elsewhere and was set up in this shell's env

    if ! ssh-add -l >& /dev/null; then
        # SSH agent has no keys

        ssh_add
    fi
elif [[ -f "$SSH_ENV" ]]; then
    # SSH agent was initialized by this script (or equivalent)

    . "$SSH_ENV" > /dev/null
    if ! [[ -e "$SSH_AUTH_SOCK"
            && -n "$SSH_AGENT_PID"
            && -n "$(ps -fp "$SSH_AGENT_PID" | grep ssh-agent)" ]]; then
        # SSH agent died

        start_ssh_agent
        ssh_add
    fi
else
    # SSH agent was not initialized

    start_ssh_agent
    ssh_add
fi

unset ssh_add
unset start_ssh_agent
