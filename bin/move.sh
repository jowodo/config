#!/usr/bin/env bash

USAGE="USAGE: move {up|down} <FROM> <TO> <BY> [ PREFIX [ POSTFIX ] ]"

if [ $# -lt 4 ] ; 
then
    echo $USAGE
    exit 1
fi

DIRECTION=$1
FROM="$2"
TO="$3"
BY=$4
PREFIX=""
POSTFIX=""
DIGITS=${#TO}
    
#echo $FROM $TO

if [ $1 == "up" ] 
then 
#    for (( i="$TO" ; i>="$FROM" ; i-- )) 
for (( i=$(echo $TO | bc) ; i>=$( echo $FROM | bc) ; i-- )) 
    do
#        echo $i
        from=${PREFIX}$( printf "%0${DIGITS}d" $i )${POSTFIX}
        to=${PREFIX}$( printf "%0${DIGITS}d" $((i+${BY})) )${POSTFIX}
#        echo $from $to 
#        mv --no-clobber ${PREFIX}${i}${POSTFIX} ${PREFIX}$(($i+${BY}))${POSTFIX}
        mv --no-clobber $from $to 
    done
elif [ $1 == "down" ] 
then 
    for (( i=$( echo $FROM| bc) ; i<=$(echo $TO | bc) ; i++ )) 
    do
#        mv --no-clobber ${PREFIX}${i}${POSTFIX} ${PREFIX}$(($i-${BY}))${POSTFIX}
        from=${PREFIX}$( printf "%0${DIGITS}d" $i )${POSTFIX}
        to=${PREFIX}$( printf "%0${DIGITS}d" $((i-${BY})) )${POSTFIX}
        mv --no-clobber $from $to 
    done
else 
    echo $USAGE
    exit 1
fi 


