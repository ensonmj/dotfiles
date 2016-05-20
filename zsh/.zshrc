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
plugins=(archlinux colored-man-pages cp docker extract fzf git go history sudo z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Disable autocorrect arguments but keep cmds
unsetopt correctall
setopt correct

#for pkgfile "command not found" hook
source /etc/profile

# Environment {{{
GDK_BACKEND=wayland
CLUTTER_BACKEND=wayland
SDL_VIDEODRIVER=wayland
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vi
export LESSCHARSET=utf-8
export PATH=$PATH:.
unset SSH_ASKPASS

#dircolors
[[ -f $HOME/.dircolors ]] && eval `dircolors $HOME/.dircolors`

#tmux
[[ -n "$TMUX" ]] && export TERM=screen-256color

# local opt bin
[[ -d $HOME/.opt/bin ]] && export PATH="$HOME/.opt/bin:$PATH"

#pandoc
[[ -d $HOME/.cabal ]] && export PATH="$PATH:$HOME/.cabal/bin"

#tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

#rbenv
if [[ -d $HOME/.rbenv ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    source $HOME/.rbenv/completions/rbenv.bash
    eval "$(rbenv init -)"
fi
export PATH="$HOME/.gem/ruby/2.3.0/bin:$PATH"

#golang
if [[ -d $HOME/Code/Go ]]; then
    export GOPATH=$HOME/Code/Go
    export PATH=$PATH:$HOME/Code/Go/bin
fi

#nvm
if [[ -d $HOME/.nvm ]]; then
    source $HOME/.nvm/nvm.sh
    source $HOME/.nvm/bash_completion

    #nvm doesn't seem to set $NODE_PATH automatically
    NP=$(which node)
    BP=${NP%bin/node} #this replaces the string 'bin/node'
    LP="${BP}lib/node_modules"
    export NODE_PATH="$LP"
fi

# }}}

# Alias {{{
alias ls='ls -F --color=auto --show-control-chars'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
alias grep="grep --color=auto"
alias vimenc='vim -c '\''let $enc=&fileencoding | execute "!echo Encoding: $enc" | q'\'''
#alias tmux='tmux -2'
alias payu="PACMAN=pacmatic nice packer -Syu"
alias gaproxy='export http_proxy=http://127.0.0.1:8087 https_proxy=http://127.0.0.1:8087'
alias noproxy='unset http_proxy https_proxy'
#}}}

# self-defined functions {{{
function man {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
}

svndiff()
{
    svn diff "$@" | dos2unix | vim - -R "+colorscheme koehler"
}

# should use colormake in github
make()
{
  pathpat="(/[^/]*)+:[0-9]+"
  ccred=$(echo -e "\033[0;31m")
  ccyellow=$(echo -e "\033[0;33m")
  ccend=$(echo -e "\033[0m")
  /usr/bin/make "$@" 2>&1 | sed -e "/[Ee]rror[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ww]arning[: ]/ s%$pathpat%$ccyellow&$ccend%g"
  return ${PIPESTATUS[0]}
}

# valgrind {{{
function vgrun
{
  local COMMAND="$1"
  local NAME="$2"
  [[ -n "$COMMAND" ]] || { echo "Syntax: vgrun <command> <name>"; return; }
  [[ -n "$NAME" ]] || { echo "Syntax vgrun <command> <name>"; return; }
  valgrind \
        --leak-check=full --error-limit=no --track-origins=yes \
        --undef-value-errors=yes --log-file=valgrind-${NAME}.log \
        --read-var-info=yes \
        $COMMAND | tee valgrind-${NAME}-output.log 2>&1
}

function vgtrace
{
  local COMMAND="$1"
  local NAME="$2"
  [[ -n "$COMMAND" ]] || { echo "Syntax: vgtrace <command> <name>"; return; }
  [[ -n "$NAME" ]] || { echo "Syntax vgtrace <command> <name>"; return; }
  valgrind \
        --leak-check=full --error-limit=no --track-origins=yes \
        --undef-value-errors=yes --log-file=valgrind-${NAME}.log \
        --read-var-info=yes --trace-children=yes \
        $COMMAND | tee valgrind-${NAME}-output.log 2>&1
}

function vgdbg
{
  [[ -n "$*" ]] || { echo "Syntax: vgrun <command>"; return; }
  valgrind \
        --leak-check=full --error-limit=no --track-origins=yes \
        --undef-value-errors=yes --read-var-info=yes --db-attach=yes \
        "$@"
}
# }}}
#}}}

# vim: foldmethod=marker
