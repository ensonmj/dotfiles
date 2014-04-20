# Path to your oh-my-zsh configuration.
ZSH=$HOME/GitRepo/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="kphoen"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(archlinux git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Disable autocorrect arguments but keep cmds
unsetopt correctall
setopt correct

#for pkgfile "command not found" hook
source /etc/profile

# Environment {{{
export EDITOR=vi
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
[ -n "$TMUX" ] && export TERM=screen-256color

# golang
if [ -n $(command -v go) -a -d $HOME/Go ]; then
    export GOPATH=$HOME/Go
    export PATH=$PATH:$GOPATH/bin
fi

# pandoc
export PATH=$PATH:$HOME/.cabal/bin

# rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"
# }}}

# Alias {{{
alias man='man -P most'
#alias tmux='tmux -2'
alias payu="PACMAN=pacmatic nice packer -Syu"
#}}}

#dircolors
if [ -f ~/.dircolors ]; then
    eval `dircolors ~/.dircolors`
fi

#tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# vim: foldmethod=marker
