#!/bin/bash

########## LOGBUCH ###
LOGBUCH=~/.local/log.cs
# letzten command ins logbuch eintragen 	$ log 
# vorletzten command ins logbuch   			$ nlog 1
function log() {
	echo $(whoami)@$(/usr/bin/date +%F/%R)$(history | tail -n 2 | head -n 1 | sed 's/ .[0-9]\+ /$/') >> $LOGBUCH
}
function nlog() {
	echo $(whoami) $(/usr/bin/date +%F/%R) $(history | tail -n "$(($1+2))" | head -n 1) >> $LOGBUCH
}
alias vlog="vim $LOGBUCH"
alias clog="cat $LOGBUCH"


########### check if a package is INSTALLED
Check () {
	dpkg -s $1 | head -n 2
}


######### CALCULATE
function c { python -c "print("$1")" ;}
### CALCULATE Only with bash
function ca { echo "$(($1))" ; }

############ TIMER
alias tell=" cvlc ~/Music/* vlc://quit" 
function alarm { sleep "$1" && tell &> /dev/null &}
function since() {
	date1=$(ps -eo pid,tty,start,cmd,user | grep -i $1 | grep $(whoami) | grep -v grep | awk '{print $3}')
	date2=$(/usr/bin/date +'%H:%M:%S') 
	datediff -i '%H:%M:%S' -f '%0H:%0M:%0S' $date1 $date2
}

########### BACKLIGHT
#function light { echo $1 > /sys/class/backlight/intel_backlight/brightness ; }
#function minlight { echo 1 > /sys/class/backlight/intel_backlight/brightness ; }
function light { xbacklight = $1 ; }
function minlight { xbacklight = 0.1; }
function mkcd { mkdir $1; cd $1; }

### ICD
if [ -f /home/pur/.icd/icd ] ; then source /home/pur/.icd/icd ; fi

# function rm { mv "$1 ~/.trash/" ; }

TRKFILE=$HOME/.trk
function trk {
	if [ $# -eq 0 ] ; then 
		tail $TRKFILE
	else 
		echo `command date +%Y.%m.%d-%H:%M` "> $@" >> $TRKFILE
	fi
}
