#
# ~/.bashrc
#

if [[ $- == *i* ]] && [[ -z "$FASTFETCH_SHOWN" ]]; then
    fastfetch
    export FASTFETCH_SHOWN=1
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
eval "$(starship init bash)"

