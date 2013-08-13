# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#for pkgfile "command not found" hook
source /etc/profile

#disable logging duplicated or blank command: ignoredups & ignorespace
export HISTCONTROL=ignoreboth
export EDITOR=vi
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
[ -n "$TMUX" ] && export TERM=screen-256color

#support pandoc
export PATH=".:$PATH:$(ruby -rubygems -e 'puts Gem.user_dir')/bin:/home/ensonmj/.cabal/bin"

#alias
alias ls='ls -F --color=auto'
alias ll='ls -l'
alias man='man -P most'

#completion
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

#tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

#rbenv
if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    source $HOME/.rbenv/completion/rbenv.bash
    eval "$(rbenv init -)"
fi

#nvm
if [ -d $HOME/.nvm ]; then
    source $HOME/.nvm/nvm.sh
    source $HOME/.nvm/bash_completion

    #nvm doesn't seem to set $NODE_PATH automatically
    NP=$(which node)
    BP=${NP%bin/node} #this replaces the string 'bin/node'
    LP="${BP}lib/node_modules"
    export NODE_PATH="$LP"
fi

PS1="\n[\[\e[36;1m\]\u\[\e[0m\]@\[\e[32;1m\]\h\[\e[0m\]:\[\e[31;1m\]\w\[\e[0m\]]\n\$ "
if [ -f /etc/bash_completion.d/git ]; then
    source /etc/bash_completion.d/git
    GIT_PS1_SHOWDIRTYSTATE='yes'
    GIT_PS1_SHOWSTASHSTATE='yes'
    GIT_PS1_SHOWUNTRACKEDFILES='yes'
    GIT_PS1_SHOWUPSTREAM="auto"
    PS1='\n[\[\e[36;1m\]\u\[\e[0m\]@\[\e[32;1m\]\h\[\e[0m\]:\[\e[31;1m\]\w\[\e[0m\]\[\e[34;1m\]$(__git_ps1 "(%s)")\[\e[0m\]]\n\$'
fi

# self defined functions
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
