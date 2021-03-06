# raspberry-embedded
Tools for make an RapberryPI run unattended.

While there are many "light" Distributions for the py nothing seems to be aimed at running unatended, embedded.

## Image Creation

```
diskutil umountDisk /dev/disk2s1
gzip -cd < klangschale-8c4-32g.image.gz | pv -petra -s 32g | sudo dd bs=8m of=/dev/rdisk2
```

```
echo “” > boot/ssh
echo ‘ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev update_config=1 country=US network={ ssid="SSID" psk="PASSWORD" key_mgmt=WPA-PSK }’ > boot/wpa_supplicant.conf
```

[Documentation](https://elinux.org/RPiconfig) for `boot/config.txt` suggests `max_usb_current=1`.

Checkout [Raspberry Pi SD Card Image Manager](https://github.com/gitbls/sdm) and [pi-boot-script](https://gitlab.com/JimDanner/pi-boot-script/-/tree/master).

## On-PI Setup

```
NEW_HOSTNAME=pi`cat /sys/firmware/devicetree/base/serial-number | cut -c 13-`
PASS=pipass
CURRENT_HOSTNAME=$(cat /etc/hostname)
if [ $NEW_HOSTNAME = $CURRENT_HOSTNAME ]; then
    echo "Name already set"
else
    echo "Setting Name" $NEW_HOSTNAME
    sudo sh -c "echo $NEW_HOSTNAME > /etc/hostname"
    sudo sed -i "/127.0.0.1/s/$CURRENT_HOSTNAME/$NEW_HOSTNAME/" /etc/hosts
fi

echo "pi:$PASS" | sudo chpasswd pi

cd ; mkdir .ssh
chmod -R 700 .ssh/

sudo apt install joe
```

## Networking

* [Simple Automatic AP for Raspberry Pi if no connected WiFi](https://github.com/gitbls/autoAP)
* [WiFi Connect](https://github.com/balena-os/wifi-connect)
sudo cp /usr/share/doc/avahi-daemon/examples/sftp-ssh.service /etc/avahi/services 


### Install ZeroTier

```
curl https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/zerotierone-archive-keyring.gpg >/dev/null
RELEASE=$(lsb_release -cs)
echo "deb [signed-by=/usr/share/keyrings/zerotierone-archive-keyring.gpg] http://download.zerotier.com/debian/$RELEASE $RELEASE main" | sudo tee /etc/apt/sources.list.d/zerotier.list
sudo apt update -y
sudo apt install -y zerotier-one
sudo zerotier-cli join $MYNETWORK
sudo zerotier-cli set $MYNETWORK allowDNS=1
```

## Optimisation

```
sudo systemctl status dphys-swapfile
sudo systemctl disable dphys-swapfile
# sudo apt-get remove dphys-swapfile 
sudo systemctl mask systemd-journald.service
sudo systemctl mask rsyslog.service
sudo apt-get install busybox-syslogd
```

* https://ikarus.sg/extend-sd-card-lifespan-with-log2ram/
* https://raspberrypi.stackexchange.com/questions/38321/raspberry-pi-lifespan-reliability
* https://mcuoneclipse.com/2019/04/01/log2ram-extending-sd-card-lifetime-for-raspberry-pi-lorawan-gateway/
* https://www.thethingsnetwork.org/forum/t/how-can-microsd-flash-memory-wear-be-minimized/15896
* https://forums.raspberrypi.com/viewtopic.php?f=41&t=850&hilit=optimizing+for+flash
* https://github.com/ecdye/zram-config

```
tune2fs -O ^has_journal /dev/sdaX
e2fsck –f /dev/sdaX
sudo reboot

fstrim /
```

## Watchdog

```
sudo apt-get install watchdog
sudo mkdir /etc/watchdog.d/
sudo sh  -c "echo '#\!/bin/sh\n# check if there is a connection to the mumble Server\nlsof -i -n | grep 139.162.144.31 | grep ESTABLISHED > /dev/null' > /etc/watchdog.d/mumble"
sudo chmod 755 /etc/watchdog.d/mumble
sudo sh  -c "echo 'interval = 7\nping = 1.1.1.1\ninterface = eth0\nmax-load-1 = 24\nmin-memory = 1\ntest-binary = /etc/watchdog.d/mumble\ntest-timeout = 120\nretry-timeout = 300\nwatchdog-device	= /dev/watchdog\nwatchdog-timeout = 15\nrealtime = yes\npriority = 1\n' > /etc/watchdog.conf"
sudo systemctl start watchdog.service
sudo systemctl status watchdog.service
```

## see also

* https://github.com/mdornseif/mifi-embedded/
* https://galaxy.ansible.com/v0rts/raspberry-pi
* https://github.com/m0by314/ansible_raspberry_pi_config/blob/master/tasks/interfacing_options/vnc.yml
* https://galaxy.ansible.com/hannseman/raspbian
* https://github.com/mikolak-net/ansible-raspi-config
* https://github.com/egvimo/ansible-collection-misc/tree/main/roles/raspberry
* https://github.com/escalate/ansible-raspberry-common
* https://docs.ansible.com/ansible/latest/collections/community/general/lldp_module.html#ansible-collections-community-general-lldp-module
* https://www.gieseke-buch.de/raspberrypi/eingebauten-hardware-watchdog-zur-ueberwachung-nutzen
* 
