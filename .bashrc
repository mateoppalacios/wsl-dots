set -o vi

if [[ ${EUID} == 0 ]] ; then
    PS1='\[\033[31m\]\h\[\033[34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[32m\]\u@\h\[\033[34m\] \w \$\[\033[00m\] '
fi

PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"

export EDITOR="vim"

export FZF_DEFAULT_COMMAND='find .'

function ccat
{
    cat "$1" | xclip -selection clipboard
}

function mmake
{
    sudo cp config.def.h config.h
    sudo make clean install
}

alias ..="cd .."
alias b="bash"
alias c="clear"
alias cdc="cd $HOME/documents/clases/"
alias gcc="gcc -Wall"
alias ls="ls -l --color=auto"
alias se="sudoedit"
alias v="vim"
alias yt="ytfzf -t"

alias ti="date +"%T""

alias bc="vim -X ~/.bashrc"
alias vc="vim -X ~/.vimrc"

alias dots='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
