#!/usr/bin/env bash
#
## DEFAULTS 
CORES=4
RAM=4G
OS="kubuntu" 
ISODIR=/home/share/isodir
# 
## Commandline parameters
help()
{
    HELPTEXT='''
    USAGE: '$0' \\\n
    [ -c | --cores <cores> ] \n
    [ -d | --drive <drive> ] (creates new if not exist)\n
    [ -i | --iso <iso-file ] \n
    [ -m | --mount ] \n 
    [ -n | --new-install ]   \n
    [ -o | --os {a[rch] | c[ent[os7]] | k[ub[untu]] | n[ix[os]] | o[[pen]bsd]
                        | w[in[10]] | u[bu[ntu]] | r[ocky] } ] \n
          default: '$OS' \n
    [ -r | --ram <ram in MB ] \n
    [ -u | --umount ] \n
    [ -h | --help ] 
    '''
    echo -e $HELPTEXT
    exit 2
}
#SHORT=v:,m:,d,c,h
SHORT=c:,d:,i:,o:,r:,m,u,n,h
LONG=cores:,drive:,iso:,os:,ram:,mount,unmount,new,cd,help
OPTS=$(getopt -a --options $SHORT --longoptions $LONG -- "$@")
eval set -- "$OPTS"
while :
do
  case "$1" in
    -c | --cores )
      CORES="$2"
      shift 2
      ;;
    -d | --drive )
#      DEPENDENTMODULES=$(echo "$2 $DEPENDENTMODULES" | xargs echo -n)
      DRIVE="$2"
      shift 2
      ;;
    -i | --iso )
      ISO="-cdrom $2 -boot once=d"
      shift 2
      ;;
    -u | --unmount )
      UNMOUNT=1
      shift;
      ;;
    -m | --mount )
      MOUNT=1
      shift;
      ;;
    -n | --new )
      REINSTALL=1
      shift;
      ;;
    -o | --os )
      OS="$2"
      shift 2
      ;;
    -r | --ram )
      RAM="$2"
      shift 2
      ;;
    -h | --help)
      help
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      help
      ;;
  esac
done
# CHECK IF A NEW VIRTUAL DRIVE NEEDS TO BE CREATED
if [[ -v DRIVE && ! -f $DRIVE ]]
then 
    NEWDRIVE=1
fi
#
if [[ "$OS" == "archos" || "$OS" == "arch" || "$OS" == "a" ]] 
then 
    VIRTHD=$ISODIR/virthd/archbox.qcow2
    ISO=$ISODIR/archlinux-2022.09.03-x86_64.iso
elif [[ "$OS" == "centos7" || "$OS" == "cent"|| "$OS" == "c"  ]] 
then 
    VIRTHD=$ISODIR/virthd/centos7.qcow2
    ISO=no-iso
elif [[ "$OS" == "kubuntu" || "$OS" == "kub"|| "$OS" == "k"  ]] 
then 
    VIRTHD=$ISODIR/virthd/kubuntu.qcow2
    ISO=$ISODIR/kubuntu-22.10-desktop-amd64.iso
elif [[ "$OS" == "nixos" || "$OS" == "nix" || "$OS" == "n" ]]
then 
    VIRTHD=$ISODIR/virthd/nixos.qcow2
    ISO=$ISODIR/nixos-minimal-22.11.2155.f413457e0dd-x86_64-linux.iso
elif [[ "$OS" == "openbsd" || "$OS" == "obsd" || "$OS" == "o" ]]
then 
    VIRTHD=$ISODIR/virthd/obsdbox.qcow2
    ISO=$ISODIR/openbsd_install70.iso
elif [[ "$OS" == "win10" || "$OS" == "win" || "$OS" == "w" ]]
then 
    VIRTHD=$ISODIR/virthd/win10.qcow2
    ISO=$ISODIR/Win10_21H1_EnglishInternational_x64.iso
elif [[ "$OS" == "ubuntu" || "$OS" == "ubu" || "$OS" == "u" ]]
then 
    VIRTHD=$ISODIR/virthd/ubuntu.qcow2
    ISO=$ISODIR/ubuntu-20.04.6-live-server-amd64.iso
    ISO=$ISODIR/ubuntu-22.04.5-live-server-amd64.iso
    ISO=$ISODIR/kubuntu-22.10-desktop-amd64.iso
elif [[ "$OS" == "rocky" || "$OS" == "r" ]]
then 
    VIRTHD=$ISODIR/virthd/rocky.qcow2
    ISO=$ISODIR/Rocky-9.5-x86_64-minimal.iso
fi 
#
if [[ $NEWDRIVE || ! -f $VIRTHD ]]
then 
    if [[ ! -v DRIVE ]] 
    then 
        DRIVE=$VIRTHD
    fi
    echo "Drive $DRIVE does not exist" 
    echo -n "Do you want to create $DRIVE? [y/n] " 
    read answer
    if [[ $answer == y || $answer == yes || $answer == Y || $answer == Yes || $answer == YES ]]
    then 
        echo -n "How big should the virtual drive be maximal in GB? "
        read size 
        # CHECK IF SIZE IS A NUMBER
        if [ -n "$size" ] && [ "$size" -eq "$size" ] 
        then 
            qemu-img create -f qcow2 $DRIVE ${size}G && VIRTHD=$DRIVE
            echo -n "." && sleep 1 
            echo -n "." && sleep 1 
            echo -n "." && sleep 1 
            echo " finished" 
        else 
            echo "$size is NOT a number! Aborting!" && exit 
        fi 
    else 
        exit 0
    fi 
fi 
#
if [ $MOUNT ] 
then 
    mkdir -p $ISODIR/mnt
    guestmount --add $VIRTHD --inspector --ro $ISODIR/mnt/
    exit 0
elif [ $UNMOUNT ]
then 
    guestunmount $ISODIR/mnt/
    exit 0
elif [[ $REINSTALL -eq 1 || $NEWDRIVE -eq 1 ]] 
then 
#    if ! [ -f $VIRTHD ] ; then 
#        qemu-img create -f qcow2 $VIRTHD 100G
#    fi
    qemu-system-x86_64 -drive file=$VIRTHD -enable-kvm -m $RAM -smp $CORES -cdrom $ISO -boot once=d & 
else 
    qemu-system-x86_64 -drive file=$VIRTHD -enable-kvm -m $RAM -smp $CORES  &
fi
#
