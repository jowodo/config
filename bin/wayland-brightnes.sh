#!/usr/bin/env bash

bfile=/sys/class/backlight/intel_backlight/brightness
bmax=$(cat /sys/class/backlight/intel_backlight/max_brightness)
bmin='1' 
binc=$(( $bmax/10 ))
bcurrent=$(cat $bfile)
help="usage: $(basename $0 ) [inc|dec]" 

if [ "$1" == 'inc' ] 
then 
	bnew=$(( $bcurrent + $binc ))
	if [ $bnew -gt $bmax ] ; then bnew=$bmax ; fi 
	if [ $bnew -gt $bmax ] ; then bnew=$bmax ; fi 
	echo $bnew > $bfile

elif [ "$1" == 'dec' ]
then
	bnew=$(( $bcurrent - $binc ))
	if [ $bnew -lt $bmin ] ; then bnew=$bmin ; fi 
	echo $bnew > $bfile
else
	echo $help
fi
exit
