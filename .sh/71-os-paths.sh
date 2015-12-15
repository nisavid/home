#!/bin/sh
# Shell runtime configuration | Java home

# Java home

_java_alt='/etc/alternatives/java'
if [ -L "$_java_alt" ]; then
    _java_alt="$(readlink -f "$_java_alt" || readlink "$_java_alt")"

    if [ -n "$_java_alt" ]; then
        JAVA_HOMES="$(printf '%s:%s' "$_java_alt" "$JAVA_HOMES")"
    fi
fi
unset _java_alt
