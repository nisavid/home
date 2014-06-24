# Bash runtime configuration | Java home


for dir in ${JAVA_HOMES[@]}; do
    if [[ -d "$dir" ]]; then
        export JAVA_HOME="$path"
        break
    fi
done
unset dir
