# zplug {{{
# export ZPLUG_HOME=$HOME/.zplug
# [[ -d $ZPLUG_HOME ]] || git clone https://github.com/zplug/zplug $ZPLUG_HOME
# source $ZPLUG_HOME/init.zsh

# zplug "zplug/zplug"
# zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh"
# zplug "plugins/archlinux", from:oh-my-zsh
# zplug "plugins/common-aliase", from:oh-my-zsh
# zplug "plugins/colored-man-pages", from:oh-my-zsh
# zplug "plugins/colorize", from:oh-my-zsh # colorize($@)
# zplug "plugins/command-not-found", from:oh-my-zsh
# zplug "plugins/copydir", from:oh-my-zsh # copydir()
# zplug "plugins/copyfile", from:oh-my-zsh # copyfile($1)
# zplug "plugins/cp", from:oh-my-zsh # cpv($@)
# zplug "plugins/dircycle", from:oh-my-zsh # C-S-Left/Right
# zplug "plugins/encode64", from:oh-my-zsh # e64($1) d64($1)
# zplug "plugins/extract", from:oh-my-zsh # x($@)
# zplug "plugins/urltools", from:oh-my-zsh # urlencode($1) urldecode($1)
# zplug "plugins/web-search", from:oh-my-zsh # google/baidu/github/ddg/wiki/...($1)
# zplug "plugins/z", from:oh-my-zsh
# zplug "plugins/git", from:oh-my-zsh
# zplug "plugins/go", from:oh-my-zsh
# zplug "plugins/svn", from:oh-my-zsh
# zplug "plugins/node", from:oh-my-zsh
# zplug "plugins/npm", from:oh-my-zsh
# # zplug "plugins/nvm", from:oh-my-zsh
# zplug "plugins/bundler", from:oh-my-zsh
# zplug "plugins/gem", from:oh-my-zsh
# zplug "plugins/rbenv", from:oh-my-zsh
# zplug "plugins/pip", from:oh-my-zsh
# zplug "plugins/sudo", from:oh-my-zsh
# zplug "themes/gnzh", from:oh-my-zsh, as:theme

# # Grab binaries from Github Release
# # and rename with the "rename-to:" tag
# zplug "junegunn/fzf", \
#     as:command, \
#     use:"bin/fzf-tmux"
# zplug "junegunn/fzf-bin", \
#     from:gh-r, \
#     as:command, \
#     rename-to:fzf, \
#     use:"*darwin*amd64*"
# zplug "andrewferrier/fzf-z"

# zplug "djui/alias-tips"
# zplug "hlissner/zsh-autopair", defer:2
# zplug "zsh-users/zsh-completions"
# zplug "zsh-users/zsh-autosuggestions"
# zplug "zsh-users/zsh-history-substring-search"
# # zsh-syntax-highlighting must be loaded after executing compinit command
# # and sourcing other plugins
# zplug "zsh-users/zsh-syntax-highlighting", defer:3

# # Install plugins if there are plugins that have not been installed
# if ! zplug check --verbose; then
#     printf "Install? [y/N]: "
#     if read -q; then
#         echo; zplug install
#     fi
# fi

# # Then, source plugins and add commands to $PATH
# # zplug load --verbose
# zplug load
# }}}

# antigen {{{
[[ -d $HOME/.zsh/antigen ]] || git clone https://github.com/zsh-users/antigen $HOME/.zsh/antigen

export adotdir=$HOME/.zsh/antigen
source $HOME/.zsh/antigen/antigen.zsh

antigen use oh-my-zsh
antigen bundles <<eobundles
    archlinux
    common-aliase
    colored-man-pages
    colorize
    command-not-found
    copydir
    copyfile
    cp
    dircycle
    encode64
    extract
    history
    tmux
    tmuxinator
    urltools
    web-search
    z
    git
    go
    svn
    node
    npm
    nvm
    bundler
    gem
    rbenv
    pip
    sudo
    andrewferrier/fzf-z
    djui/alias-tips
    hlissner/zsh-autopair
    zsh-users/zsh-completions
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-history-substring-search
    zsh-users/zsh-syntax-highlighting
eobundles
antigen theme gnzh
antigen apply
# }}}

# zsh option {{{
# Disable autocorrect arguments but keep cmds
unsetopt correctall
setopt correct

autoload -U zmv
# autoload run-help

# bindkey
# \^ = ctrl
# \^[ = esc
# }}}

# Environment {{{
GDK_BACKEND=wayland
CLUTTER_BACKEND=wayland
SDL_VIDEODRIVER=wayland
export LC_ALL=en_US.utf8
export LANG=en_US.utf8
export EDITOR=vim
export LESSCHARSET=utf-8
export PATH=$PATH:.
unset SSH_ASKPASS

#dircolors
[[ -f $HOME/.dircolors ]] && eval `dircolors $HOME/.dircolors`

# local opt bin
[[ -d $HOME/.opt/bin ]] && export PATH="$HOME/.opt/bin:$PATH"

#pandoc
[[ -d $HOME/.cabal ]] && export PATH="$PATH:$HOME/.cabal/bin"

#golang
[[ -d $HOME/go ]] && export PATH="$PATH:$HOME/go/bin"
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
if [[ -d $HOME/Code/hadoop-client ]]; then
    alias hd='$HOME/Code/hadoop-client/hadoop/bin/hadoop --config $HOME/Code/hadoop-client/hadoop/conf/mulan'
    alias hdol='$HOME/Code/hadoop-client/hadoop/bin/hadoop --config $HOME/Code/hadoop-client/hadoop/conf/khan'
fi
#}}}

# Automatically quote globs in URL and remote references
__remote_commands=(scp rsync wget curl)
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zstyle -e :urlglobber url-other-schema '[[ $__remote_commands[(i)$words[1]] -le ${#__remote_commands} ]] && reply=("*") || reply=(http https ftp)'

# self-defined functions {{{
# function man
# {
#     env LESS_TERMCAP_mb=$'\E[01;31m' \
#         LESS_TERMCAP_md=$'\E[01;38;5;74m' \
#         LESS_TERMCAP_me=$'\E[0m' \
#         LESS_TERMCAP_se=$'\E[0m' \
#         LESS_TERMCAP_so=$'\E[38;5;246m' \
#         LESS_TERMCAP_ue=$'\E[0m' \
#         LESS_TERMCAP_us=$'\E[04;38;5;146m' \
#         man "$@"
# }

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
make () {
  pathpat="(/[^/]*)+:[0-9]+"
  ccred=$(echo -e "\033[0;31m")
  ccyellow=$(echo -e "\033[0;33m")
  ccend=$(echo -e "\033[0m")
  /usr/bin/make "$@" 2>&1 | sed -e "/[Ee]rror[: ]/ s%$pathpat%$ccred&$ccend%g" -e "/[Ww]arning[: ]/ s%$pathpat%$ccyellow&$ccend%g"
  return ${PIPESTATUS[0]}
}

# valgrind {{{
vgrun () {
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

vgtrace () {
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

vgdbg () {
  [[ -n "$*" ]] || { echo "Syntax: vgrun <command>"; return; }
  valgrind \
        --leak-check=full --error-limit=no --track-origins=yes \
        --undef-value-errors=yes --read-var-info=yes --db-attach=yes \
        "$@"
}
# }}}
#}}}

# vim: foldmethod=marker
