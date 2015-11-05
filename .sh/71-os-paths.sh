#!/bin/sh
# Shell runtime configuration | Java home

# Java home
java_alt='/etc/alternatives/java'
if [ -L "$java_alt" ]; then
    java_alt="$(readlink -f "$java_alt" || readlink "$java_alt")"

    if [ -n "$java_alt" ]; then
        JAVA_HOMES="$(printf '%s\0%s' "$java_alt" "$JAVA_HOMES")"
    fi
fi
unset java_alt
