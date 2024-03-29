# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# aliases
alias zshconfig="vim ~/dotfiles-local/zshrc.local"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias home="cd ~"
alias y10="tmux resize-pane -y 10"
alias y20="tmux resize-pane -y 20"
alias y30="tmux resize-pane -y 30"
alias y40="tmux resize-pane -y 40"
alias x75="tmux resize-pane -x 75"
alias x100="tmux resize-pane -x 100"
alias x200="tmux resize-pane -x 200"
# assign custom key mappings for linux
alias map-keys="xmodmap ~/dotfiles-local/.Xmodmap"
# remove tap to click on linux
alias remove-tap-click="synclient MaxTapTime=0"
alias qa-backend="ssh -i ~/.ssh/simadmin.pem -p 6000 -L 9050:localhost:9050 simadmin@qa-portal"
alias azul="~/dev/azul"
alias azul-load-dev="~/dev/azul load -p create delete edit view approve deny"

# run zsh in vi mode
set -o vi

# terminal vim
bindkey -v
export KEYTIMEOUT=10
bindkey -M viins 'jk' vi-cmd-mode

# git vim editor
export GIT_EDITOR=nvim

# show which vim mode we are in
precmd() {
  RPROMPT=""
}
zle-keymap-select() {
  RPROMPT=""
  [[ $KEYMAP = vicmd ]] && RPROMPT="(COMMAND MODE)"
  () { return $__prompt_status }
  zle reset-prompt
}
zle-line-init() {
  typeset -g __prompt_status="$?"
}
zle -N zle-keymap-select
zle -N zle-line-init

# start z fuzzy finder on zsh load
. ~/dotfiles/z.sh

# NPM configuration for global package user permissions
# Solution found here:
# https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
NPM_PACKAGES="${HOME}/.npm-packages"

PATH="$PATH:$NPM_PACKAGES/bin:${HOME}/dev/ci/portal"
export GPG_TTY=$(tty)

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FZF_DEFAULT_COMMAND='ag --nocolor --ignore node_modules -g ""'
