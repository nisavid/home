# Path to your oh-my-zsh installation.
export ZSH="$HOME"/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME='robbyrussell'

DEFAULT_USER="$USER"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE=true

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE=true

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS=true

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE=true

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS=true

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY=true

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS='yyyy-mm-dd'

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(catimg colored-man colorize command-not-found compleat dirhistory safe-paste screen zsh-syntax-highlighting history-substring-search adb autopep8 brew coffee common-aliases cp emoji encode64 fabric git git-extras git-flow git-hubflow git-remote-branch gitignore history iwhois jruby jsontools knife knife_ssh mercurial node npm nvm pep8 pip postgres pyenv pylint python rails rake redis-cli ruby rvm systemadmin systemd torrent urltools vi-mode vim-interaction virtualenv wd web-search zeus)

# External settings -----------------------------------------------------------

[[ -f "$ZSH"/oh-my-zsh.sh ]] && source "$ZSH"/oh-my-zsh.sh

[[ -f "$HOME"/.shrc ]] && source "$HOME"/.shrc
