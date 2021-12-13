#!/bin/sh
# installs a Mumble Client
sudo apt install snapd
sudo snap install mumble
mkdir .config/autostart
sudo sh  -c "echo '[Desktop Entry]\nType=Application\nName=Mumble\nExec=mumble mumble://${NAME}:Dreifaltig@mumble.ins.foxel.org:64738/klang' > .config/autostart/mumble.desktop"
# audio setup. Works well with focusrite hardware
sudo sh  -c "echo 'pactl list short sinks\npacmd set-default-sink 2\npactl list short sources\npacmd set-default-source 3\nexit 0' > /etc/rc.local"

# remove default config
rm -Rf ./snap/mumble/1676/.local/share/Mumble/Mumble 

# mumble watchdog to restart if connection fails
sudo apt-get install watchdog
sudo mkdir /etc/watchdog.d/
sudo sh  -c "echo '#\!/bin/sh\n# check if there is a connection to the mumble Server\nlsof -i -n | grep 139.162.144.31 | grep ESTABLISHED > /dev/null' > /etc/watchdog.d/mumble"
udo chmod 755 /etc/watchdog.d/mumble
sudo sh  -c "echo 'interval = 7\nping = 139.162.144.31\ninterface = eth0\nmax-load-1 = 24\nmin-memory = 1\ntest-binary = /etc/watchdog.d/mumble\ntest-timeout = 120\nretry-timeout = 300\nwatchdog-device	= /dev/watchdog\nwatchdog-timeout = 15\nrealtime = yes\npriority = 1\n' > /etc/watchdog.conf"
sudo systemctl start watchdog.service
sudo systemctl status watchdog.service
