#!/bin/sh

# Install Oh-My-Zsh custom plugins via Git
#
# Each directory alongside this script that contains a git_remote_uri
# file is treated as input.  The contents of each git_remote_uri should
# be the URI of the corresponding plugin's remote repository.  This
# script clones each URI in the user's Oh-My-Zsh custom plugins
# directory.

src_root="$($(dirname $0)/../../../bin/sh-readlink -f $(dirname $0))"

dest_root="$HOME"/.oh-my-zsh/custom/plugins

mkdir -p "$dest_root" || exit 1
cd "$dest_root" \
  && { find "$src_root" -mindepth 1 -maxdepth 1 -type d \
         | while read plugin_dir; do
               plugin_name="$(basename "$plugin_dir")"
               echo "installing plugin $plugin_name" >&2
               if [ -f "$plugin_dir"/git_remote_uri ] \
                  && [ ! -e "$plugin_name" ]; then
                   git clone \
                       "$(cat "$plugin_dir"/git_remote_uri | tr -d '\r\n')" \
                       "$plugin_name"
               fi
           done
       cd - > /dev/null
     }
