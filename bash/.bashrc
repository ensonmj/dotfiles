# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#for pkgfile "command not found" hook
source /etc/profile

#disable logging duplicated or blank command: ignoredups & ignorespace
export HISTCONTROL=ignoreboth
export EDITOR=vim
#performance acceleration for sort etc.
export LC_ALL=C
export LANG=en_US.UTF-8
export LESSCHARSET=utf-8
unset SSH_ASKPASS

if [ -z "$TMUX" ]; then
    #run this outside of tmux!
    for name in `tmux ls -F '#{session_name}'`; do
        tmux setenv -g -t $name DISPLAY $DISPLAY #set display for all sessions
    done
fi

[ -n "$TMUX" ] && export TERM=screen-256color

#support pandoc
if [ -d ~/.cabal ]; then
    export PATH=".:$PATH:$(ruby -rubygems -e 'puts Gem.user_dir')/bin:~/.cabal/bin"
fi

#alias
alias ls='ls -F --color=auto --show-control-chars'
alias la='ls -a'
alias ll='ls -l'
alias man='man -P most'
alias vimenc='vim -c '\''let $enc=&fileencoding | execute "!echo Encoding: $enc" | q'\'''

#completion
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

#dircolors
if [ -f ~/.dircolors ]; then
    eval `dircolors ~/.dircolors`
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

# valgrind
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
