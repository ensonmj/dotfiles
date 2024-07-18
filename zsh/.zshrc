# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Environment {{{
emulate sh -c 'source /etc/profile'
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'
# https://superuser.com/a/1749784
[[ -n "$PROMPT_COMMAND" ]] && precmd() { eval "$PROMPT_COMMAND" }

# ZSH_CACHE_DIR
[[ -d $HOME/.zsh/cache ]] || mkdir -p "$HOME/.zsh/cache" && export ZSH_CACHE_DIR=$HOME/.zsh/cache

# }}}

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
    docker
    encode64
    extract
    history
    #tmux
    #tmuxinator
    urltools
    web-search
    z
    git
    go
    #node
    #npm
    #nvm
    #pip
    sudo
    andrewferrier/fzf-z
    djui/alias-tips
    hlissner/zsh-autopair
    marlonrichert/zsh-autocomplete@main
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

# zsh-autocomplete
# Make Tab go straight to the menu and cycle there
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# Automatically quote globs in URL and remote references
__remote_commands=(scp rsync wget curl)
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zstyle -e :urlglobber url-other-schema '[[ $__remote_commands[(i)$words[1]] -le ${#__remote_commands} ]] && reply=("*") || reply=(http https ftp)'
# }}}

# PS1 {{{
command -v starship &> /dev/null && eval "$(starship init zsh)"
# }}}
command -v zellij &> /dev/null && eval "$(zellij setup --generate-auto-start zsh)"

# vim: foldmethod=marker
