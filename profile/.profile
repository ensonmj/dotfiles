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
#	. "$HOME/.bashrc"
#    fi
#fi

# Alias {{{
alias ls='ls -F --color=auto --show-control-chars'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
alias grep="grep --color=auto"
alias vimenc='vim -c '\''let $enc=&fileencoding | execute "!echo Encoding: $enc" | q'\'''
#alias tmux='tmux -2'
alias payu="PACMAN=pacmatic nice packer -Syu"
# }}}

# Environment {{{
GDK_BACKEND=wayland
CLUTTER_BACKEND=wayland
SDL_VIDEODRIVER=wayland
#performance acceleration for sort etc.
export LC_ALL=C
#export LC_ALL=en_US.utf8
export LANG=en_US.UTF-8
export LESSCHARSET=utf-8
export EDITOR=vim
export PATH=$PATH:.
unset SSH_ASKPASS

# set PATH so it includes user's private bin if it exists
[[ -d $HOME/bin ]] && export PATH="$HOME/bin:$PATH"
[[ -d $HOME/.opt/bin ]] && export PATH="$HOME/.opt/bin:$PATH"
[[ -d $HOME/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"

#pandoc
[[ -d $HOME/.cabal/bin ]] && export PATH="$PATH:$HOME/.cabal/bin"
# }}}

# Load scripts {{{
#dircolors
[[ -f $HOME/.dircolors ]] && eval `dircolors $HOME/.dircolors`

#rust
if [ -d $HOME/.cargo ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
    source $HOME/.cargo/env
fi

#golang
if [ -d $HOME/go ]; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$HOME/go/bin
fi

#nvm
if [ -d $HOME/.nvm ]; then
    source $HOME/.nvm/nvm.sh
    #source $HOME/.nvm/bash_completion

    #nvm doesn't seem to set $NODE_PATH automatically
    NP=$(which node)
    BP=${NP%bin/node} #this replaces the string 'bin/node'
    LP="${BP}lib/node_modules"
    export NODE_PATH="$LP"
fi

#rbenv
if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    source $HOME/.rbenv/completions/rbenv.bash
    eval "$(rbenv init -)"
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
# https://gist.github.com/yougg/5d2b3353fc5e197a0917aae0b3287d64
function proxy () {
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

function gitproxy() {
    local PROTO="${1:-http}" # http, https
    local HOST="${2:-127.0.0.1}"
    local PORT="${3:-1080}"
    local ADDR="$PROTO://$HOST:$PORT"

    # set git http(s) proxy
    git config --global http.sslverify false
    git config --global http.proxy "$ADDR"
    git config --global https.proxy "$ADDR"

    # set git ssh proxy
    local SSH_PROXY="ProxyCommand=nc -X 5 -x $HOST:$PORT %h %p"
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
