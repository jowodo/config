#
# ~/.bashrc
#

EDITOR=vim
BROWSER=firefox
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

PATH=$PATH:/home/pur/.local/bin

# vim control in bash
set -o vi

if [ -f ~/.bash_aliases ] ; then
	source ~/.bash_aliases ; fi

if [ -f ~/.bash_functions ] ; then
	source ~/.bash_functions ; fi

if [ -f ~/.bash_local ] ; then
	source ~/.bash_local; fi

LANG=en_US.UTF-8
HISTSIZE=-1
