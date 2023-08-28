#!/bin/bash
# ^ For shellcheck's happiness

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
#if [ -n "$BASH_VERSION" ]; then
#    # include .bashrc if it exists
#    if [ -f "$HOME/.bashrc" ]; then
#        . "$HOME/.bashrc"
#    fi
#fi

# Alias {{{
# enable color support of ls and also add handy aliases
if command -v dircolors &> /dev/null ; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ls='ls -F --show-control-chars'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
alias vimenc='vim -c '\''let $enc=&fileencoding | execute "!echo Encoding: $enc" | q'\'''
#alias tmux='tmux -2'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# }}}

# Environment {{{
# GDK_BACKEND=wayland
# CLUTTER_BACKEND=wayland
# SDL_VIDEODRIVER=wayland

#performance acceleration for sort etc.
#export LC_ALL=C
#zsh PROMPT can be disrupted by "LC_ALL=C"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LESSCHARSET=utf-8
export EDITOR=vim
unset SSH_ASKPASS
# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# enable public access for X11, this should just set on ssh client side {{{
# export DISPLAY=$(ip route list default | awk '{print $3}'):0
# export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
# export DISPLAY=$(host `hostname` | grep -oP '(\s)\d+(\.\d+){3}' | tail -1 | awk '{ print $NF }' | tr -d '\r'):0
# export LIBGL_ALWAYS_INDIRECT=1
# }}}

# set PATH so it includes user's private bin if it exists
[[ -d $HOME/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"
if [ -d $HOME/.opt ]; then
    for SUB in $HOME/.opt/*; do
        [[ -d $SUB/bin ]] && export PATH="$SUB/bin:$PATH"
    done
fi
[[ -d /snap/bin ]] && export PATH="$PATH:/snap/bin"
[[ -d $HOME/.cabal/bin ]] && export PATH="$PATH:$HOME/.cabal/bin" #pandoc
export PATH=.:$PATH

#tmux
if [ -z "$TMUX" ]; then
    #run this outside of tmux!
    if [ -n "$DISPLAY" ]; then
        for name in `tmux ls -F '#{session_name}' 2>/dev/null`; do
            tmux setenv -g -t $name DISPLAY $DISPLAY #set display for all sessions
        done
    fi
else
    #inside tmux!
    export TERM=screen-256color
fi
# }}}

# Load scripts {{{
#tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

#nix
# [[ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]] && source $HOME/.nix-profile/etc/profile.d/nix.sh

#homebrew
[[ -d $HOME/.linuxbrew ]] && eval "$($HOME/.linuxbrew/bin/brew shellenv)"
[[ -d /home/linuxbrew/.linuxbrew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
if command -v brew &> /dev/null && brew list | grep coreutils > /dev/null ; then
    PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
    MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
fi

#rust
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

#golang
if [ -d $HOME/go ]; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$HOME/go/bin
fi

#nvm
if [ -d $HOME/.nvm ]; then
    source $HOME/.nvm/nvm.sh

    #nvm doesn't seem to set $NODE_PATH automatically
    NP=$(which node)
    BP=${NP%bin/node} #this replaces the string 'bin/node'
    LP="${BP}lib/node_modules"
    export NODE_PATH="$LP"
fi

#rbenv
if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

#dotenv
# https://gist.github.com/mihow/9c7f559807069a03e302605691f85572
# s/\r//g remove carriage return(\r)
# "s/'/'\\\''/g" replaces every single quote with '\'', which is a trick sequence in bash to produce a quote :)
# "s/=\(.*\)/='\1'/g" converts every a=b into a='b'
[ -f $HOME/.env ] && while read -r LINE; do
    if [[ $LINE != '#'* ]] && [[ $LINE == *'='* ]]; then
        ENV_VAR=$(echo $LINE | sed -e 's/\r//g' -e "s/'/'\\\''/g")
        eval "export $ENV_VAR"
    fi
done < $HOME/.env
# }}}

# self-defined functions {{{
function ostype() {
  case "$OSTYPE" in
    solaris)       echo "SOLARIS" ;;
    darwin*)       echo "OSX" ;;
    linux*)        echo "LINUX" ;;
    bsd*)          echo "BSD" ;;
    msys|cygwin)   echo "WINDOWS" ;;
    *)             echo "unknown: $OSTYPE" ;;
  esac
}

# env {{{
function env_do() {
    env $(cat .env) $@
}

function env_load() {
    # https://stackoverflow.com/questions/12916352/shell-script-read-missing-last-line
    while read -r LINE || [ -n "$LINE" ]; do
        if [[ $LINE != '#'* ]] && [[ $LINE == *'='* ]]; then
            ENV_VAR=$(echo $LINE | sed -e 's/\r//g' -e "s/'/'\\\''/g")
            eval "export $ENV_VAR"
        fi
    done < $1
}
#}}}

# path {{{
function path_add() {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            # Prepending path in case a system-installed needs to be overridden
            export PATH="$1:$PATH"
            ;;
    esac
}

# Safely remove the given entry from $PATH
# https://unix.stackexchange.com/a/253760/143394
function path_del() {
    while case $PATH in
            "$1") unset PATH; false;;
            "$1:"*) PATH=${PATH#"$1:"};;
            *":$1") PATH=${PATH%":$1"};;
            *":$1:"*) PATH=${PATH%%":$1:"*}:${PATH#*":$1:"};;
            *) false;;
        esac
    do
        :
    done
}
#}}}

# json {{{
function trim_comment() {
    sed "s|[ \t]*//.*$||" $1 | sed "/^$/d"
}

function merge_json() {
    jq -s '[.[][]]' <(trim_comment $1) <(trim_comment $2)
}
#}}}

# proxy {{{
# https://gist.github.com/yougg/5d2b3353fc5e197a0917aae0b3287d64
function proxy() {
    local PROTO="${1:-socks5}" # socks5(local DNS), socks5h(remote DNS), http, https
    local HOST="${2:-127.0.0.1}"
    local PORT="${3:-8080}"
    local ADDR="$PROTO://$HOST:$PORT"

    export http_proxy=$ADDR https_proxy=$ADDR ftp_proxy=$ADDR rsync_proxy=$ADDR all_proxy=$ADDR
    export HTTP_PROXY=$ADDR HTTPS_PROXY=$ADDR FTP_PROXY=$ADDR RSYNC_PROXY=$ADDR ALL_PROXY=$ADDR

    no_proxy="127.0.0.1,localhost,.localdomain.com"
    no_proxy=$no_proxy,`echo 10.{0..255}.{0..255}.{0..255}|tr ' ' ','`
    no_proxy=$no_proxy,`echo 172.{16..31}.{0..255}.{0..255}|tr ' ' ','`
    no_proxy=$no_proxy,`echo 192.168.{0..255}.{0..255}|tr ' ' ','`
    export no_proxy
    export NO_PROXY="$no_proxy"
}

function noproxy() {
    unset http_proxy https_proxy ftp_proxy rsync_proxy all_proxy no_proxy
    unset HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY NO_PROXY
}

function wgetproxy() {
    local HOST="${1:-127.0.0.1}"
    local PORT="${2:-8080}"
    local ADDR="http://$HOST:$PORT"

    echo "http_proxy=$ADDR" >> ~/.wgetrc
    echo "https_proxy=$ADDR" >> ~/.wgetrc
}

function nowgetproxy() {
    sed -i '/http_proxy/d' ~/.wgetrc
    sed -i '/https_proxy/d' ~/.wgetrc
}

function gitproxy() {
    local PROTO="${1:-http}" # http, https
    local HOST="${2:-127.0.0.1}"
    local PORT="${3:-1080}"
    local ADDR="$PROTO://$HOST:$PORT"

    SSH_PROXY_PROTO="-X 5" # socks 5 for default
    if [ "$PROTO" == "http" -o "$PROTO" == "https" ]; then
        SSH_PROXY_PROTO="-X connect"

        # set git http(s) proxy
        git config --global http.sslverify false
        git config --global http.proxy "$ADDR"
        git config --global https.proxy "$ADDR"
    fi

    # set git ssh proxy
    local SSH_PROXY="ProxyCommand=nc $SSH_PROXY_PROTO -x $HOST:$PORT %h %p"
    git config --global core.sshCommand "ssh -o '$SSH_PROXY'"

    # only for 'github.com'
    # git config --global http.https://github.com.proxy "$ADDR"

    # replace "git://" with "ssh://"
    # git config --global url.'ssh://git@github.com/'.insteadOf 'git://github.com/'
}

function nogitproxy() {
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    git config --global --unset core.sshCommand

    # git config --global --unset http.https://github.com.proxy

    # git config --global --remove-section url.'ssh://git@github.com/'
}

function sshproxy() {
    local TARGET_ADDR="${1}"
    local HOST="${2:-127.0.0.1}"
    local PORT="${3:-22}"
    local USER="${4}"

    # # use 'nc' with http protocol
    # local SSH_PROXY="ProxyCommand=nc -X connect -x $HOST:$PORT %h %p"

    # # use 'nc' with http protocol and proxy user
    # local SSH_PROXY="ProxyCommand=nc -X connect -x $HOST:$PORT -P $USER %h %p"

    # use 'nc' with socks5 protocol
    local SSH_PROXY="ProxyCommand=nc -X 5 -x $HOST:$PORT %h %p"

    # # use 'connect' with http protocol
    # local SSH_PROXY="ProxyCommand=connect -H $HOST:$PORT %h %p"

    # # use 'connect' with http protocol and proxy user
    # local SSH_PROXY="ProxyCommand=connect -H $USER@$HOST:$PORT %h %p"

    # # use 'connect' with HTTP_PROXY environment
    # local SSH_PROXY="ProxyCommand=connect -h %h %p"

    # # use 'connect' with socks5 protocol
    # local SSH_PROXY="ProxyCommand=connect -S $HOST:$PORT %h %p"

    # # use 'connect' with socks5 protocol and user
    # local SSH_PROXY="ProxyCommand=connect -S $USER@$HOST:$PORT %h %p"

    # # use 'connect' with SOCKS5_SERVER environment
    # export SOCKS5_SERVER="$HOST:$PORT"
    # export SOCKS5_USER="$USER"
    # export SOCKS5_PASSWD="$PASS"
    # local SSH_PROXY="ProxyCommand=connect -s %h %p"

    # connect to ssh server over proxy
    ssh -o "$SSH_PROXY" $TARGET_ADDR
}
# }}}

# pfwd server port
function pfwd() {
    ssh -fNT -L 127.0.0.1:$2:127.0.0.1:$2 $1 && echo "Port forward to http://127.0.0.1:$2"
}

function svn() {
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
function make() {
    pathpat="(/[^/]*)+:[0-9]+"
    ccred=$(echo -e "\033[0;31m")
    ccyellow=$(echo -e "\033[0;33m")
    ccend=$(echo -e "\033[0m")
    /usr/bin/make "$@" 2>&1 | sed -e "/[Ee]rror[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ww]arning[: ]/ s%$pathpat%$ccyellow&$ccend%g"
    return ${PIPESTATUS[0]}
}

# docker {{{
function docker_attach() {
    local CONTAINER="$1"
    local WORKDIR="${2:-/workspaces/$CONTAINER}"
    docker exec -itu vscode --privileged -e DISPLAY=$DISPLAY -w $WORKDIR $CONTAINER zsh
}
#}}}

# valgrind {{{
function vgrun() {
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

function vgtrace() {
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

function vgdbg() {
    [[ -n "$*" ]] || { echo "Syntax: vgrun <command>"; return; }
    valgrind \
        --leak-check=full --error-limit=no --track-origins=yes \
        --undef-value-errors=yes --read-var-info=yes --db-attach=yes \
        "$@"
}
# }}}
# }}}

# vim: foldmethod=marker
