MAINUSER=pur
SECOND_USER=cube


[ "$(id -u $MAINUSER 2>/dev/null)" == "" ] && useradd -m $MAINUSER
[ "$(id -u $SECOND_USER 2>/dev/null)" == "" ] && useradd -m $SECOND_USER
pacman -S reflector
reflector | grep -v rsync | sudo tee /etc/pacman.d/mirrorlist
pacman -S archlinux-keyring intel-ucode
grub-mkconfig -o /boot/grub/grub.cfg

## FILESYSTEM
pacman -S exfat-utils fuse2fs nfs-utils lsof ntfs-3g
pacman -S testdisk #recovery tool
pacman -S usbutils # lsusb

## NETWORK
pacman -S openssh rsync wget ufw
groupadd netwrk
usermod -aG netwrk $MAINUSER 
usermod -aG netwrk $SECOND_USER
#echo "cat /etc/netctl/examples/wireless-wpa-configsection | sudo tee -a /etc/netctl/wlp2s0-eduroam"

# EXTRA SOFTWAR
pacman -S unzip htop sudo 
pacman -S vim vim-spell-de ed tmux screen ranger
usermod -aG wheel $MAINUSER

# PROGRAMMING 
pacman -S base-devel r python-pip python-numpy python-matplotlib
pacman -S r gcc-fortran

# GRAPHICAL USER INTERFACE
pacman -S xorg-xinput xorg-xkill i3-gaps i3lock-color dmenu autorandr terminus-font
pacman -S zathura zathura-pdf-mupdf gvim alacritty
pacman -S kolourpaint scrot imagemagick gimp mtpaint gnuplot 
pacman -S texlive-latexextra texlive-most texlive-formatsextra
pacman -S youtube-dl ktorrent
pacman -S signal-desktop telegram-desktop thunderbird firefox brave
pacman -S libreoffice-fresh libreoffice-fresh-de
tee /etc/X11/xorg.conf.d/70-synaptics.conf<<EOF
Section "InputClass"
	Identifier "touchpad"
	Driver "synaptics"
	MatchIsTouchpad "on"
		Option	"TapButton1"	"1"
		Option	"TapButton2"	"3"
		Option	"TapButton3"	"2"
		Option	"VertTwoFingerScroll"	"on"
		Option	"HorizTwoFingerScroll"	"on"
		Option	"VertScrollDelta"	"-40"
		Option	"HorizScrollDelta"	"-40"
EndSection
EOF
pushd /usr/local/src/
	STVERSION=0.8.5
	wget https://dl.suckless.org/st/st-${STVERSION}.tar.gz 
	tar xf st-${STVERSION}.tar.gz
	rm st-${STVERSION}.tar.gz
	cd st-${STVERSION}
	echo 'static char *font = "Liberation Mono:pixelsize=24:antialias=true:autohint=true";'>> config.h
	sed "s/pixelsize=12/pixelsize=24/" config.h
	sed "s/XK_Prior/XK_K/g" config.h
	sed "s/XK_Next/XK_J/g" config.h
	sed "s/XK_Home/XK_H/g" config.h
	make 
	mv st /usr/local/bin/
popd
#echo 10 | sudo tee /sys/class/backlight/intel_batcklighet
chmod 664 /sys/class/backlight/intel_backlight/brightness
chown root:video /sys/class/backlight/intel_backlight/brightness
usermod -aG video $MAINUSER

# pacman -S deeping-extra cutefish
# usermod -aG rfkill,netwrk,music karin

## MEDIA
pacman -S vlc mpv pasystray volumeicon pavucontrol
pacman -S pulseaudio-bluetooth bluedevil blueman bluez-utils bluez bluez-tools alsa-utils 
sudo usermod -aG rfkill,audio $MAINUSER

## DAW
#qjackctl & vmpk & amsynth & daw
#pacman -S a2jmidid jack_capture pulseaudio-jack python-rdflib zita-ajbridge 
#pacman -S celt libffado jack_utils qjackctl alsa-utils cadence
#pacman -S ams calf zynaddsubfx hyrdogen # synthesizer and drum machine
#pacman -S ardour ladspa vmpk realtime-privileges non-sequencer
#usermod -aG realtime,rtkit pur
##echo "@audio - rtprio 99" | sudo tee -a /etc/security/limits.conf
#mkinitcpio -p linux

## PASSWORDS 
sudo pacman -S pass keepass

## LANGUAGES
pacman -S noto-fonts-cjk # non-latin japanese, chinese, korean


## POWER MANAGEMENT
pacman -S acpi tlp
systemctl enable acpid.service
#pur@2021-07-04/09:3012739 sudo vim /etc/udev/rules.d/99-lowbat.rules # see archwiki laptop
#pur@2021-04-08/18:23$ sudo vim /usr/local/bin/set_DISPLAY_for_sleep.sh
#pur@2021-04-08/18:24$ sudo chmod +x /usr/local/bin/set_DISPLAY_for_sleep.sh
tee -a /etc/udev/rules.d/99-lowbat.rules <<EOF
# Suspend the system when battery level drops to 5 precent or lower 
SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-5]", RUN+="/usr/bin/systemctl hibernate"
EOF

#TODO back light hibernation and sleep 
echo "HandleLidSwitch=suspend-then-hibernate" >> /etc/systemd/logind.conf
sed -i "s/block/block resume/" /etc/mkinitcpio.conf
echo "# resume added to HOOKS"
mkinitcpio -p linux
echo $SWAPUUID=$(grep swap /etc/fstab| awk '{print $1}')
cp /etc/default/grub /etc/default/grub.bkp
sed -i "/s/quiet/quiet resume=${SWAPUUID}/" /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
sed -i "s/#AllowSuspendThenHibernate/AllowSuspendThenHibernate/" /etc/systemd/sleep.conf
echo "HibernateDelaSec=15min" >> /etc/systemd/sleep.conf
tee /etc/systemd/system/suspend@.service<<EOF
[Unit]
Description=User suspend actions
Before=sleep.target

[Service]
User=%I
Type=forking
ExecStartPre=/usr/local/bin/set_DISPLAY_for_sleep.sh %I
EnvironmentFile=/home/%I/.display
ExecStart=/usr/bin/i3lock -i /home/%I/Pics/lock.png
ExecStartPost=/usr/bin/sleep 1

[Install]
WantedBy=sleep.target
EOF
systemctl enable suspend@${MAINUSER}.service
#echo mkdir /etc/systemd/system/hibernate.target.wants
#echo ln -s -T /etc/systemd/system/resume@${MAINUSER}.service /etc/systemd/system/hibernate.target.wants/resume@pur.service

# get config files
su - ${MAINUSER}
DOTFOLDER=/home/${MAINUSER}/.config/dotfiles
mkdir -p $DOTFOLDER
git clone https://github.com/pur80a/config_files.git $DOTFOLDER
ln -s $DOTFOLDER/.Xkb-ak-gh.xkb	~/.Xkb-ak-gh.xkb # akan
ln -s $DOTFOLDER/bashrc  	~/.bashrc
ln -s $DOTFOLDER/bash_alias  	~/.bash_alias
ln -s $DOTFOLDER/bash_functions ~/.bash_functions
ln -s $DOTFOLDER/vimrc 		~/.vimrc
ln -s $DOTFOLDER/i3_config 	~/.config/i3/config
ln -s $DOTFOLDER/i3status_config ~/.config/i3status/config


## FINGERPRINT 
#pacman -S fprintd # fingerprint reader

## VIRTUAL MACHINES
pacman -S qemu
pacman -Syu virt-install # kvm for qemu
#yay -S woeusb # win10.iso

## TTS 
pacman -S espeak
pacman -S spectacle festival festival-us festival-english

