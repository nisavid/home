#!/usr/bin/env bash

export SSH_ASKPASS='/usr/bin/ssh-askpass'

if ! ssh-add -l &> /dev/null; then
    ssh-add < /dev/null
fi
