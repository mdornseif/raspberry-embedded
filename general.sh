#!/bin/sh 
# general raspberry pi setup
# Oress Ctrl-Shift-X in Raspberry Pi Imager !
export NAME=PINAME 
sudo sh  -c "echo ${NAME} > /etc/hostname"
mkdir .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYmHfIoM6OhPubRsby224mhrF/tslA/ZrwUeMVEX0QYxbNJSq+OK2q4dmW2edWEyG6g8VKWLMNoKmoSCqiidRpTRcArvqVMo4PPx0ozvE4hb4XKGDILoV+Z4DWZ58Ij1fzonRfbggHosp5imKzulGDYEgBlxAeayN/3QZsjWVtWuAU+KvPlfhI6wYw1A7IrJgw/SrgovuKFHWc6caZAJPhd/jMmr8kadGUprH2RTedBPBKvo0koFDwAwe4GhAxZa2FsvttjZ/3liaFX3b0/b5SomQ/rR7LxHwafV6PiTxLdRdPjbFpYABRdfWayIyNQ5qHMRtHgm1i4vbjh7df9FZB mistakenot" > .ssh/authorized_keys
chmod -R 700 .ssh/
echo "pi:XXXXXXX" |  sudo chpasswd  pi
echo "country=DE" >> /etc/wpa_supplicant/wpa_supplicant.conf
sudo sh -c “echo framebuffer_width=1024 >> /boot/config.txt”
sudo sh -c “echo framebuffer_height=768 >> /boot/config.txt”
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt install joe wicd-curses hostapd dnsmasq comitup

sudo rfkill unblock wlan

# https://github.com/davesteele/comitup/wiki/Installing-Comitup

# ssh pi@192.178.7.2 sudo date -s$(date -Ins); ssh pi@192.178.7.2 sudo hwclock -w
