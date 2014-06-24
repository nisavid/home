# Bash runtime configuration | operating system paths


# Java home
java_alt='/etc/alternatives/java'
if [[ -L "$java_alt" ]]; then
    java_home="$(readlink -f "$java_alt" || readlink "$java_alt")"
    if [[ -n "$path" ]]; then
        JAVA_HOMES=("$java_home" ${JAVA_HOMES[@]})
    fi
fi
unset java_alt
unset java_home
