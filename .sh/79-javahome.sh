# shellcheck shell=sh
# Shell configuration | Java home

while [ -n "$JAVA_HOMES" ] && [ ! "$abort" ]; do
    _java_home="${JAVA_HOMES%%:*}"

    if [ -e "$_java_home" ]; then
        export JAVA_HOME="$_java_home"
        break
    fi

    if [ "$JAVA_HOMES" = "$_java_home" ]; then
        JAVA_HOMES=''
    else
        JAVA_HOMES="${JAVA_HOMES#*:}"
    fi
done
unset _java_home
