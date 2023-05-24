# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Environment && Init scripts {{{
#for pkgfile "command not found" hook
source /etc/profile

[[ -f ~/.profile ]] && source ~/.profile

#disable logging duplicated or blank command: ignoredups & ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[[ -f $HOME/.nvm/bash_completion ]] && source $HOME/.nvm/bash_completion
[[ -f $HOME/.rbenv/completions/rbenv.bash ]] && source $HOME/.rbenv/completions/rbenv.bash

# }}}

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

command -v starship &> /dev/null && eval "$(starship init bash)"
# }}}

# self-defined functions {{{
function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
}

function colors() {
    for x in {0..8}; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo ""
}

function colors2() {
    local fgc bgc vals seq0

    # shellcheck disable=SC2016
    printf 'Color escapes are %s\n' '\e[${value};...;${value}m'
    printf 'Values 30..37 are \e[33mforeground colors\e[m\n'
    printf 'Values 40..47 are \e[43mbackground colors\e[m\n'
    printf 'Value  1 gives a  \e[1mbold-faced look\e[m\n'
    printf '%s\n\n' 'printf "\e[m" resets'

    # foreground colors
    for fgc in $(seq 30 37); do
        # background colors
        for bgc in $(seq 40 47); do
            fgc=${fgc#37} # white
            bgc=${bgc#40} # black

            vals="${fgc:+$fgc;}${bgc}"
            vals=${vals%%;}

            seq0="${vals:+\e[${vals}m}"
            printf "  %-9s" "${seq0:-(default)}"
            printf " %sTEXT\\e[m" "${seq0}"
            printf ' \e[%s1mBOLD\e[m' "${vals:+${vals+$vals;}}"
        done
        echo; echo
    done
}

# }}}

# vim: foldmethod=marker
