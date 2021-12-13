#!/bin/sh 
# general raspberry pi setup
export NAME=PINAME 
sudo sh  -c "echo ${NAME} > /etc/hostname"
mkdir .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYmHfIoM6OhPubRsby224mhrF/tslA/ZrwUeMVEX0QYxbNJSq+OK2q4dmW2edWEyG6g8VKWLMNoKmoSCqiidRpTRcArvqVMo4PPx0ozvE4hb4XKGDILoV+Z4DWZ58Ij1fzonRfbggHosp5imKzulGDYEgBlxAeayN/3QZsjWVtWuAU+KvPlfhI6wYw1A7IrJgw/SrgovuKFHWc6caZAJPhd/jMmr8kadGUprH2RTedBPBKvo0koFDwAwe4GhAxZa2FsvttjZ/3liaFX3b0/b5SomQ/rR7LxHwafV6PiTxLdRdPjbFpYABRdfWayIyNQ5qHMRtHgm1i4vbjh7df9FZB mistakenot" > .ssh/authorized_keys
chmod -R 700 .ssh/
sudo apt install joe
echo "pi:XXXXXXX" |  sudo chpasswd  pi
sudo sh -c “echo framebuffer_width=1024 >> /boot/config.txt”
sudo sh -c “echo framebuffer_height=768 >> /boot/config.txt”
