#!/bin/sh
set -e

usage="\
usage: install.sh [options] [packages] [modules]

Install the home directory files corresponding to the specified modules.

Running this without any packages or modules is equivalent to running
with --all-cli.

Each module corresponds to a set of files that shall be installed in the
home directory of the current user.  Some files are installed as
symlinks to the corresponding files in the directory that contains this
install script.

Packages are collections of modules.  When specifying a package, any of
its included modules may be excluded via the corresponding --no-MODULE
flags, and other modules may be added via the corresponding --MODULE
flags.  To see the modules that are included in a package, run this
script with --dry-run and the desired package.

packages:
  --all          install all modules
  --all-cli      install all modules that are relevant in a command line
                 environment (without a desktop environment)
  --all-sh       install all shell configuration modules
  --all-ruby     install all Ruby modules

modules:
  --[no-]bin     link ~/bin/ files
  --[no-]sh      link ~/.sh/ files
  --[no-]bash    link ~/.bash/ files
  --[no-]zsh     link ~/.zsh/ files
  --[no-]oh-my-zsh
                 install Oh-My-Zsh
  --[no-]oh-my-zsh-custom
                 install Oh-My-Zsh custom plugins
  --[no-]git     link ~/.gitconfig
  --[no-]irb     link ~/.irbrc
  --[no-]rvm     link ~/.rvmrc

options:
  -n, --dry-run  simulate events that would occur but do not write any
                 changes
  -f, --force    overwrite any prior destination files
  -k, --keep-going
                 if a module fails to install, proceed with installing the
                 remaining modules
  --help         display this help and exit"

all_modules="\
bin
sh
bash
zsh
oh-my-zsh
oh-my-zsh-custom
git
irb
rvm
kde"

all_cli_modules="\
bin
sh
bash
zsh
oh-my-zsh
oh-my-zsh-custom
git
irb
rvm"

all_ruby_modules="\
irb
rvm"

all_sh_modules="\
sh
bash
zsh
oh-my-zsh
oh-my-zsh-custom"

src_root_unresolved="$(dirname "$0")"
src_root="$("$src_root_unresolved"/bin/sh-readlink -f "$src_root_unresolved")"

parse_args() {
    modules_on=
    modules_off=
    modules=

    while [ $# -gt 0 ]; do
        arg_str="$1"
        shift

        module_off="$(printf %s -- "$arg_str" | sed -n 's/^--no-\(.*\)$/\1/p')"
        if [ -n "$module_off" ] \
           && printf %s "$all_modules" | grep -q ^"$module_off"$; then
            modules_off="$modules_off\n$module_off"
        else
            module_on="$(printf %s -- "$arg_str" | sed -n 's/^--\(.*\)$/\1/p')"
            if [ -n "$module_on" ] \
               && printf %s "$all_modules" | grep -q ^"$module_on"$; then
                modules_on="$modules_on\n$module_on"
            else
                case "$arg_str" in
                  --all)
                    modules="$modules\n$all_modules"
                    ;;
                  --all-cli)
                    modules="$modules\n$all_cli_modules"
                    ;;
                  --all-ruby)
                    modules="$modules\n$all_ruby_modules"
                    ;;
                  --all-sh)
                    modules="$modules\n$all_sh_modules"
                    ;;
                  --dry-run | -n)
                    dry_run=true
                    ;;
                  --force | -f)
                    force=true
                    ;;
                  --keep-going | -k)
                    keep_going=true
                    ;;
                  --help)
                    echo "$usage"
                    exit
                    ;;
                  *)
                    echo "$usage" >&2
                    exit 2
                    ;;
                esac
            fi
        fi
    done
    modules_on="$(printf %s "$modules_on" | tail -n +2)"
    modules_off="$(printf %s "$modules_off" | tail -n +2)"

    if [ -z "$modules" ] && [ -z "$modules_on" ] && [ -z "$modules_off" ]; then
        modules="$(printf '%s\n%s' "$modules" "$all_cli_modules")"
    fi

    modules="$(printf '%s\n%s' "$modules" "$modules_on" | sed /^$/d | uniq)"

    if [ -n "$modules_off" ]; then
        modules_off_sed_args="$(for module in $(printf %s "$modules_off" | xargs); do printf %s " -e /$module/d"; done)"
        # shellcheck disable=SC2086
        modules="$(printf %s "$modules" | sed $modules_off_sed_args)"
    fi
}

parse_args "$@"

printf 'installing modules:'
for module in $modules; do
    printf %s " $module"
done
printf '\n'

echo using \'"$src_root"\' as root directory for installation sources and symlink targets

modules_specs="\
bin link_bin_files linking ~/bin/ files
sh link_sh_files linking shell files
bash link_bash_files linking Bash files
oh-my-zsh install_omz installing Oh-My-Zsh
oh-my-zsh-custom install_omz_custom installing Oh-My-Zsh custom plugins
zsh link_zsh_files linking Zsh files
git link_gitconfig linking ~/.gitconfig
irb link_irbrc linking ~/.irbrc
rvm link_rvmrc linking ~/.rvmrc
kde link_kde_files linking ~/.kde/ files
"

# module functions ------------------------------------------------------------

link() {
    link='command ln'
    if [ "$force" ]; then
        link="${link} -f"
    fi
    $link "$@"
}

link_bin_files() {
    mkdir -p "$HOME"/bin
    $link "$src_root"/bin/* "$HOME"/bin/
}

link_sh_files() {
    $link "$src_root"/.shrc "$HOME"/.shrc
    mkdir -p "$HOME"/.sh
    $link "$src_root"/.sh/* "$HOME"/.sh/
}

link_bash_files() {
    $link "$src_root"/.bash_profile "$HOME"/.bash_profile
    $link "$src_root"/.bashrc "$HOME"/.bashrc
    mkdir -p "$HOME"/.bash
    $link "$src_root"/.bash/* "$HOME"/.bash/
}

install_omz() {
    if [ "$force" ]; then
        rm -rf "$HOME"/.oh-my-zsh
    fi

    [ ! -e "$HOME"/.oh-my-zsh ]

    # XXX: ignore exit status because (as of 2015-09-13) it is always nonzero on Linux
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
        || true
}

install_omz_custom() {
    "$src_root"/.oh-my-zsh/custom/plugins/install.sh
}

link_zsh_files() {
    $link "$src_root"/.zshrc "$HOME"/.zshrc
    mkdir -p "$HOME"/.zsh
    $link "$src_root"/.zsh/* "$HOME"/.zsh/
}

link_gitconfig() {
    $link "$src_root"/.gitconfig "$HOME"/.gitconfig
}

link_irbrc() {
    $link "$src_root"/.irbrc "$HOME"/.irbrc
}

link_rvmrc() {
    $link "$src_root"/.rvmrc "$HOME"/.rvmrc
}

link_kde_files() {
    cd "$src_root"
    # shellcheck disable=SC2086
    find .kde -type f -exec $link "$HOME"/\{\} "$src_root"/\{\} \;
    cd - >/dev/null
}

printf %s "$modules_specs" | while read -r module_name module_func module_message; do
    if printf %s "$modules" | grep -q ^"$module_name"$; then
        echo "$module_message"
        if [ ! "$dry_run" ]; then
            (set -e; "$module_func")
            ret=$?
            [ $ret -eq 0 ] || [ "$keep_going" ] || exit $ret
        fi
    fi
done
