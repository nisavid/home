#!/bin/sh

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

src_root="$($(dirname $0)/bin/sh-readlink -f $(dirname $0))"

os="$(uname -s)"
distro=
if [ "$os" = 'Linux' ]; then
    if [ -n "$(grep Ubuntu /etc/*-release)" ]; then
        distro='Ubuntu'
    elif [ -n "$(grep Mint /etc/*-release)" ]; then
        distro='Mint'
    fi
fi

parse_args() {
    modules_on=
    modules_off=
    modules=

    while [ $# -gt 0 ]; do
        arg_str="$1"
        shift

        module_off="$(printf -- $arg_str | sed -n 's/^--no-\(.*\)$/\1/p')"
        if [ -n "$module_off" ] \
           && [ -n "$(printf "$all_modules" | grep ^"$module_off"$)" ]; then
            modules_off="$modules_off\n$module_off"
        else
            module_on="$(printf -- $arg_str | sed -n 's/^--\(.*\)$/\1/p')"
            if [ -n "$module_on" ] \
               && [ -n "$(printf "$all_modules" | grep ^"$module_on"$)" ]; then
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
    modules_on="$(printf "$modules_on" | tail -n +2)"
    modules_off="$(printf "$modules_off" | tail -n +2)"

    if [ -z "$modules" ] && [ -z "$modules_on" ] && [ -z "$modules_off" ]; then
        modules="$modules\n$all_cli_modules"
    fi

    modules="$(printf "$modules\n$modules_on" | sed /^$/d | uniq)"

    if [ -n "$modules_off" ]; then
        modules_off_sed_args="$(for module in $(printf "$modules_off" | xargs); do printf " -e /$module/d"; done)"
        modules="$(printf "$modules" | sed $modules_off_sed_args)"
    fi
}

parse_args $@

link='ln -s'
if [ "$force" ]; then
    link="${link}f"
fi

printf 'installing modules:' >&2
for module in $modules; do
    printf " $module" >&2
done
printf '\n' >&2

echo using \'"$src_root"\' as root directory for installation sources and symlink targets \
  >&2

if [ -n "$(printf "$modules" | grep ^bin$)" ]; then
    echo 'linking ~/bin/ files' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        mkdir -p "$HOME"/bin || fail=true
        $link "$src_root"/bin/* "$HOME"/bin/ || fail=true
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^sh$)" ]; then
    echo 'linking ~/.sh/ files' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        $link "$src_root"/.shrc "$HOME"/.shrc || fail=true
        mkdir -p "$HOME"/.sh || fail=true
        $link "$src_root"/.sh/* "$HOME"/.sh/ || fail=true
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^bash$)" ]; then
    echo 'linking ~/.bash/ files' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        $link "$src_root"/.bash_profile "$HOME"/.bash_profile || fail=true
        $link "$src_root"/.bashrc "$HOME"/.bashrc || fail=true
        mkdir -p "$HOME"/.bash || fail=true
        $link "$src_root"/.bash/* "$HOME"/.bash/ || fail=true
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^zsh$)" ]; then
    echo 'linking ~/.zsh/ files' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        $link "$src_root"/.zshrc "$HOME"/.zshrc || fail=true
        mkdir -p "$HOME"/.zsh || fail=true
        $link "$src_root"/.zsh/* "$HOME"/.zsh/ || fail=true
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^oh-my-zsh$)" ]; then
    echo 'installing Oh-My-Zsh' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        if [ "$force" ]; then
            rm -rf "$HOME"/.oh-my-zsh || fail=true
        fi

        if [ -e "$HOME"/.oh-my-zsh ]; then
            fail=true
        else
            sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
              || fail=true
        fi
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^oh-my-zsh-custom$)" ]; then
    echo 'installing Oh-My-Zsh custom plugins' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        "$src_root"/.oh-my-zsh/custom/plugins/install.sh || fail=true
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^git$)" ]; then
    echo 'linking ~/.gitconfig' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        $link "$src_root"/.gitconfig "$HOME"/.gitconfig || fail=true
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^irb$)" ]; then
    echo 'linking ~/.irbrc' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        $link "$src_root"/.irbrc "$HOME"/.irbrc || fail=true
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^rvm$)" ]; then
    echo 'linking ~/.rvmrc' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        $link "$src_root"/.rvmrc "$HOME"/.rvmrc || fail=true
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi

if [ -n "$(printf "$modules" | grep ^kde$)" ]; then
    echo 'linking ~/.kde/ files' >&2
    unset fail
    if [ ! "$dry_run" ]; then
        pushd "$src_root" > /dev/null \
          && { find .kde -type f -exec $link "$HOME"/\{\} "$src_root"/\{\} \; \
                 || fail=true
               popd > /dev/null
             }
    fi
    [ "$fail" ] && [ ! "$keep_going" ] && exit 1
fi
