#
# ~/.bash_aliases
#

alias ls='ls --color=auto --group-directories-first -F'
alias lsn="ls --color=no -F"

#PROGRAMS
alias e="evince $1 2> /dev/null "
alias fire="firefox 2> /dev/null &"
alias gp="gnuplot"
alias via="vim ~/.bash_aliases"
alias vif="vim ~/.bash_functions"
alias vis="vim ~/.ssh/config"
alias vir="vim ~/.bashrc"
alias sus="source /home/pur/.bashrc "


###===System===###
alias pu="ping -c 2 bestoked.at"
#reactivate pointing stick after sleep/hibernation
alias mouse="sudo modprobe -r psmouse && sudo modprobe psmouse"

#NAVIATION
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -iv"
alias l="ls -l"
alias duh="du -hd 1  | sort -h"
alias ll="ls -l"
alias lash="ls -lash"

#BACKUP

#DOCUMENTS
alias d.="dolphin . &> /dev/null &"
alias v.="vlc . &> /dev/null &"
alias v="vlc"

alias ohrwurm="vim ~/Music/Noten/ohrwurm.txt"

#PROGRAMS

alias gp="gnuplot"
alias li="libreoffice"
alias py="python"
alias ytdl="youtube-dl -x --audio-format \"mp3\" "

#special RROG
alias fet="figlet"
alias fett="banner"
alias hamsar="py3 ~/Code/Python/Hamsar/Hamsar2.2/hams.py"
alias hams="py3 ~/Code/Python/Hamsar/Hamsar2.2/hams.py"
alias hams="cd ~/Code/Python/Hamsar/Hamsar2.2/"

#test
alias mic-test="arecord -vv -f dat /dev/null"

#temporary
alias x="startx && reset"
alias i3="startx /usr/bin/i3"
alias kde="startx /usr/bin/startplasma-x11"
alias bigfont="setfont sun12x22"

#often used
alias de="setxkbmap de"
alias us="setxkbmap us"
alias date="date +'%a %d %b %Y %H:%m:%S %Z'"
alias since="/usr/bin/date && ps -eo pid,tty,start,cmd | grep -i $1"
alias wifi="sudo systemctl restart netctl-auto@wlp2s0.service"
alias getconf="cd /home/pur/Documents/Computer/Config_files.git && git pull && source ~/.bashrc && cd -"
alias gitconf="cd /home/pur/Documents/Computer/Config_files.git && git add * && git commit && git push && source ~/.bashrc && cd - "
alias bt="rfkill unblock bluetooth && sudo systemctl start bluetooth && bluetoothctl"
alias btoff="sudo systemctl stop bluetooth* && rfkill block bluetooth"
alias td="termdown"

alias smount="sudo systemd-mount --owner=$USER"
alias sumount="sudo systemd-mount -u"
alias hibernate="sudo systemctl hibernate"
alias suspend="sudo systemctl suspend"
alias todo="vim ~/.todo"
