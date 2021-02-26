#!/bin/bash

application_file_path="/vagrant/installed-application.md"

# prerequisits
sudo apt update
sudo apt dist-upgrade -y

# install tools
sudo apt install -y build-essential dkms unzip wget

# reboot

# repository
sudo vi /etc/apt/sources.list
# deb http://download.virtualbox.org/virtualbox/debian bionic contrib
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt update

# install virtualbox
sudo apt install virtualbox-6.1 -y
sudo usermod -aG vboxusers vagrant
sudo systemctl status vboxdrv

# Install VirtualBox Extension pack
wget https://download.virtualbox.org/virtualbox/6.1.18/Oracle_VM_VirtualBox_Extension_Pack-6.1.18.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.18.vbox-extpack

# Install phpVirtualBox in Ubuntu 18.04 LTS
sudo apt install apache2 php php-mysql libapache2-mod-php php-soap php-xml
wget https://github.com/phpvirtualbox/phpvirtualbox/archive/5.2-1.zip
unzip 5.2-1.zip
sudo mv phpvirtualbox-5.2-1/ /var/www/html/phpvirtualbox
sudo chmod 777 /var/www/html/phpvirtualbox/
sudo cp /var/www/html/phpvirtualbox/config.php-example /var/www/html/phpvirtualbox/config.php
sudo vi /var/www/html/phpvirtualbox/config.php

sudo vi /etc/default/virtualbox
# VBOXWEB_USER=vagrant
sudo systemctl restart vboxweb-service
sudo systemctl restart vboxdrv
sudo systemctl restart apache2

# firewall
sudo ufw app list
sudo ufw app info "Apache Full"
sudo ufw allow in "Apache Full"
sudo ufw app info "Apache"


sudo wget http://archive.getdeb.net/install_deb/getdeb-repository_0.1-1~getdeb1_all.deb
sudo dpkg -i getdeb-repository_0.1-1~getdeb1_all.deb 
wget -q -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install remotebox