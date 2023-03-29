# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Environment {{{
[[ -e ~/.profile ]] && source ~/.profile
# }}}

#for pkgfile "command not found" hook
source /etc/profile

# Environment && Init scripts {{{
#disable logging duplicated or blank command: ignoredups & ignorespace
export HISTCONTROL=ignoreboth

if [ -d $HOME/.nvm ]; then
    source $HOME/.nvm/bash_completion
fi
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
#}}}

# vim: foldmethod=marker
