#!/usr/bin/env bash

# Install Oh-My-Zsh custom plugins via Git
#
# Each directory alongside this script that contains a git_remote_uri
# file is treated as input.  The contents of each git_remote_uri should
# be the URI of the corresponding plugin's remote repository.  This
# script clones each URI in the user's Oh-My-Zsh custom plugins
# directory.

src="$(pwd)/$(dirname "$0")"

OMZ_CUSTOM_PLUGINS_DIR="$HOME"/.oh-my-zsh/custom/plugins

mkdir -p "$OMZ_CUSTOM_PLUGINS_DIR" \
 && pushd "$OMZ_CUSTOM_PLUGINS_DIR" > /dev/null \
 && { find "$src" -mindepth 1 -maxdepth 1 -type d \
       | while read plugin_dir; do
             echo $plugin_dir
             plugin_name="$(basename "$plugin_dir")"
             if [[ -f "$plugin_dir"/git_remote_uri \
                   && ! -e "$plugin_name" ]]; then
                 git clone \
                     "$(cat "$plugin_dir"/git_remote_uri | tr -d '\r\n')" \
                     "$plugin_name"
             fi
         done
      popd > /dev/null
    }
