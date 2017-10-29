#!/bin/sh

# Install Oh-My-Zsh custom plugins via Git
#
# Each directory alongside this script that contains a git_remote_uri
# file is treated as input.  The contents of each git_remote_uri should
# be the URI of the corresponding plugin's remote repository.  This
# script clones each URI in the user's Oh-My-Zsh custom plugins
# directory.

src_root="$("$(dirname "$0")"/../../../bin/sh-readlink -f "$(dirname "$0")")"

dest_root="$HOME"/.oh-my-zsh/custom/plugins

mkdir -p "$dest_root" || exit
cd "$dest_root" || exit

find "$src_root" -mindepth 1 -maxdepth 1 -type d \
    | while read -r plugin_dir; do

    plugin_name="$(basename "$plugin_dir")"
    if [ -f "$plugin_dir"/git_remote_uri ] && [ ! -e "$plugin_name" ]; then
        echo "Installing plugin $plugin_name" >&2
        git clone "$(tr -d '\r\n' < "$plugin_dir"/git_remote_uri)" "$plugin_name"
    fi
done
