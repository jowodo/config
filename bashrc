#
# ~/.bashrc
#

export EDITOR=vim
export BROWSER=firefox
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

PATH=$PATH:~/.local/bin

# vim control in bash
set -o vi

export XDG_CONFIG_HOME=~/Doc/Computer/Config_files.git
if [ -f ~/.bash_aliases ] ; then source ~/.bash_aliases ; fi
if [ -f $XDG_CONFIG_HOME/bash_aliases ] ; then source $XDG_CONFIG_HOME/bash_aliases ; fi

if [ -f ~/.bash_functions ] ; then source ~/.bash_functions ; fi
if [ -f $XDG_CONFIG_HOME/bash_functions ] ; then source $XDG_CONFIG_HOME/bash_functions ; fi

if [ -f ~/.bash_local ] ; then source ~/.bash_local; fi
if [ -f $XDG_CONFIG_HOME/bash_local ] ; then source $XDG_CONFIG_HOME/bash_local; fi

LANG=en_US.UTF-8
HISTSIZE=-1
if [ -f /home/pur/.icd/icd ] ; then source /home/pur/.icd/icd ; fi

