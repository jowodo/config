#!/bin/bash 
#
## DEFAULTS 
CORES=4
RAM=4G
OS="nixos" 
# 
## Commandline parameters
help()
{
    HELPTEXT='''
    USAGE: $0 \\\n
    [ -c | --cores <cores> ] \n
    [ -d | --drive <drive> ] \n
    [ -i | --iso <iso-file ] \n
    [ -n | --new-install ]   \n
    [ -r | --ram <ram in MB ] \n
    [ -o | --os {a[rch]|c[ent[os7]]|k[ub[untu]]|n[ix[os]]|o[[pen]bsd]|w[in[10]]} ] \n
    [ -h | --help ] 
    '''
    echo -e $HELPTEXT
    exit 2
}
SHORT=v:,m:,d,c,h
SHORT=c:,d:,i:,o:,r:,n,h
LONG=cores:,drive:,iso:,os:,ram:,new,cd,help
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

if [[ "$OS" == "archos" || "$OS" == "arch" || "$OS" == "a" ]] 
then 
    VIRTHD=/home/pur/Doc/Computer/Distros/archbox.qcow2
    ISO=/home/pur/Doc/Computer/Distros/archlinux-2022.09.03-x86_64.iso
elif [[ "$OS" == "centos7" || "$OS" == "cent"|| "$OS" == "c"  ]] 
then 
    VIRTHD=/home/share/centos7.qcow2
    ISO=no-iso
elif [[ "$OS" == "kubuntu" || "$OS" == "kub"|| "$OS" == "k"  ]] 
then 
    VIRTHD=/home/pur/Doc/Computer/Distros/kubuntu.qcow2
    ISO=/home/pur/Doc/Computer/Distros/kubuntu-22.10-desktop-amd64.iso
elif [[ "$OS" == "nixos" || "$OS" == "nix" || "$OS" == "n" ]]
then 
    VIRTHD=/home/pur/Doc/Computer/Distros/nixos.qcow2
    ISO=/home/pur/Doc/Computer/Distros/nixos-minimal-22.11.2155.f413457e0dd-x86_64-linux.iso
elif [[ "$OS" == "openbsd" || "$OS" == "obsd" || "$OS" == "o" ]]
then 
    VIRTHD=/home/pur/Doc/Computer/Distros/obsdbox.qcow2
    ISO=/home/pur/Doc/Computer/Distros/openbsd_install70.iso
elif [[ "$OS" == "win10" || "$OS" == "win" || "$OS" == "w" ]]
then 
    VIRTHD=/home/share/win10.qcow2
    ISO=/home/pur/Doc/Computer/Distros/Win10_21H1_EnglishInternational_x64.iso
fi 
#
if [ $REINSTALL ] 
then 
    if ! [ -f $VIRTHD ] ; then 
        qemu-img create -f qcow2 $VIRTHD 20G
    fi
    qemu-system-x86_64 -drive file=$VIRTHD -enable-kvm -m $RAM -smp $CORES -cdrom $ISO -boot once=d & 
else 
    qemu-system-x86_64 -drive file=$VIRTHD -enable-kvm -m $RAM -smp $CORES  &
fi
#
