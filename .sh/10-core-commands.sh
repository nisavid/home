# Shell runtime configuration | core commands


for path_ in /usr/local/bin/grep /usr/bin/grep /bin/grep; do
    if [[ -s "$path_" ]]; then
        export GREP="$path_"
        break
    fi
done
unset path_
