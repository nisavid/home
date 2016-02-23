#!/bin/sh
# Shell configuration | Java home

# Java home

_java_alt='/etc/alternatives/java'
if [ -L "$_java_alt" ]; then
    _java_alt="$(readlink -f "$_java_alt" || readlink "$_java_alt")"

    if [ -n "$_java_alt" ]; then
        JAVA_HOMES="$(printf '%s:%s' "$_java_alt" "$JAVA_HOMES")"
    fi
fi
unset _java_alt

if [ -x '/usr/libexec/java_home' ]; then
    _java_home="$(/usr/libexec/java_home 2>/dev/null)"
    if [ -d "$_java_home" ]; then
        JAVA_HOMES="$(printf '%s:%s' "$_java_home" "$JAVA_HOMES")"
    fi
fi
unset _java_home

jvm_use() {
    JAVA_HOME="$(/usr/libexec/java_home -v "$1")"
    export JAVA_HOME
}
