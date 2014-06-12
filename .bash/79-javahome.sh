# Bash runtime configuration | Java home


for path in ${JAVA_HOME_CANDIDATES[@]}; do
    if [[ -d "$path" ]]; then
        export JAVA_HOME="$path"
        break
    fi
done
unset path
