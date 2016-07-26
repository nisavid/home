#!/bin/bash
# Bash configuration | development

[[ $- == *i* ]] || return
# Interactive shell -----------------------------------------------------------

# rails5-demo -----------------------------------------------------------------

function in_r5 {
    in_dir "$HOME"/src/rails5-demo "$@"
}

function r5bi {
    r5bun install "$@"
}

function r5bu {
    r5bun update "$@"
}

function r5bun {
    in_r5 r5rvm 'do' bundle "$@"
}

function r5ra {
    in_r5 rails "$@"
}

function r5rk {
    r5z rake "$@"
}

function r5rvm {
    rvm rails5-demo "$@"
}

function r5z {
    in_r5 r5rvm 'do' zeus "$@"
}
