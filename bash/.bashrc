# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#for pkgfile "command not found" hook
source /etc/profile

# Alias {{{
alias ls='ls -F --color=auto --show-control-chars'
alias la='ls -a'
alias ll='ls -l'
alias grep="grep --color=auto"
alias vimenc='vim -c '\''let $enc=&fileencoding | execute "!echo Encoding: $enc" | q'\'''
# }}}

# Environment && Init scripts {{{
#disable logging duplicated or blank command: ignoredups & ignorespace
export HISTCONTROL=ignoreboth
export EDITOR=vim
#performance acceleration for sort etc.
export LC_ALL=C
export LANG=en_US.UTF-8
export LESSCHARSET=utf-8
unset SSH_ASKPASS
export PATH=$PATH:.

#rbenv
if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    source $HOME/.rbenv/completions/rbenv.bash
    eval "$(rbenv init -)"
fi

#golang
if [ -d $HOME/Go ]; then
    export GOPATH=$HOME/Go
    export PATH=$PATH:$HOME/Go/bin
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

#pandoc
if [ -d $HOME/.cabal ]; then
    export PATH="$PATH:$HOME/.cabal/bin"
fi

#dircolors
if [ -f $HOME/.dircolors ]; then
    eval `dircolors $HOME/.dircolors`
fi

#tmux
if [ -z "$TMUX" ]; then
    #run this outside of tmux!
    for name in `tmux ls -F '#{session_name}' 2>/dev/null`; do
        tmux setenv -g -t $name DISPLAY $DISPLAY #set display for all sessions
    done
else
    #inside tmux!
    export TERM=screen-256color
fi

#tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
# }}}

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

svn () {
    if [[ "$1" == "log" ]]; then
        # -FX tell `less` to quit if entire file fits on the first screen, not to switch to the alternate screen
        command svn "$@" | less -FX
    elif [[ "$1" == "diff" ]]; then
        command svn "$@" | dos2unix | vim - -R "+colorscheme koehler"
    else
        command svn "$@"
    fi
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

# PS1 {{{
function git_since_last_commit
{
    now=`date +%s`;
    last_commit=$(git log --pretty=format:%at -1 2> /dev/null) || return;
    seconds_since_last_commit=$((now-last_commit));
    minutes_since_last_commit=$((seconds_since_last_commit/60));
    hours_since_last_commit=$((minutes_since_last_commit/60));
    minutes_since_last_commit=$((minutes_since_last_commit%60));
    echo "\e[31;1m|\e[34;1m ${hours_since_last_commit}h${minutes_since_last_commit}m";
}

PS1="\n[\[\e[36;1m\]\u\[\e[0m\]@\[\e[32;1m\]\h\[\e[0m\]:\[\e[31;1m\]\w\[\e[0m\]]\n\$ "
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE='yes'
    GIT_PS1_SHOWSTASHSTATE='yes'
    GIT_PS1_SHOWUNTRACKEDFILES='yes'
    GIT_PS1_SHOWUPSTREAM="auto"
    PS1='\n[\[\e[36;1m\]\u\[\e[0m\]@\[\e[32;1m\]\h\[\e[0m\]: \[\e[31;1m\]\w\[\e[34;1m\] $(__git_ps1 "(%s $(git_since_last_commit))")\[\e[0m\]]\n\$'
fi
#}}}

# vim: foldmethod=marker
