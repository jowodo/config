#!/bin/bash

########## LOGBUCH ###
LOGBUCH=~/Documents/Computer/log.cs
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

### CHANGING OF FOLDERS Inteligently 
function icd() {
	# make a history and search history first 
	# store it in ~/.icd
	# make it a script
	# if no argument go home
	# find "in_time" or "in time" with icd in time
	#cd $( find -iname $1 | head - -n 1 )
	#cd $( find . | grep -ie $1 | head - -n 1 )
	#cd $( find . -type d | grep -m 1 -ie $1 )
	#cd $( find . -type d -iname $1 | head - -n 1 )
	#cd $( find ~ -not -path '*/\.*' -type d -iname $1* | head - -n 1 )
	cd "$( find ~ -not -path '*/\.*' -type d -iname $1* | head - -n 1 | sed -e 's/ /\\ /')"
	pwd
}

######### CALCULATE
function c { python -c "print("$1")" ;}
### CALCULATE Only with bash
function ca { echo "$(($1))" ; }

############ TIMER
alias tell=" cvlc ~/Music/* vlc://quit" 
function alarm { sleep "$1" && tell &> /dev/null &}

########### BACKLIGHT
#function light { echo $1 > /sys/class/backlight/intel_backlight/brightness ; }
#function minlight { echo 1 > /sys/class/backlight/intel_backlight/brightness ; }
function light { xbacklight = $1 ; }
function minlight { xbacklight = 1; }
function mkcd { mkdir $1; cd $1; }
