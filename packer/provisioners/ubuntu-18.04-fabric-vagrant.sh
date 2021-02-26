#!/bin/bash

# define provisioning steps
sudo apt-get update
sudo apt install -y dconf-editor

echo "##########################################"
echo "# install jq                             #"
echo "##########################################"
sudo apt-get install -y jq

echo "##########################################"
echo "# install jfrog client                   #"
echo "##########################################"
sudo curl -s -fL https://getcli.jfrog.io | sh
sudo chmod +x jfrog
sudo mv jfrog /bin/jfrog

echo "##########################################"
echo "# configure desktop                      #"
echo "##########################################"
sudo dbus-launch gsettings set org.mate.caja.desktop computer-icon-visible "true"
sudo dbus-launch gsettings set org.mate.caja.desktop network-icon-visible "true"
sudo dbus-launch gsettings set org.mate.caja.desktop trash-icon-visible "true"

echo "##########################################"
echo "# install jenkins                        #"
echo "##########################################"
# install jdk
sudo apt install -y openjdk-8-jdk
# add keys
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
# install Jenkins
sudo apt install -y jenkins
# set password for jenkins user
echo -e "jenkins\njenkins" | sudo passwd jenkins
# add jenkins user to sudors
sudo adduser jenkins sudo
sudo systemctl restart jenkins

echo "##########################################"
echo "# create ssh key                         #"
echo "##########################################"
echo "" | ssh-keygen -t rsa -b 4096 -C "vagrant.fabric@labs" -q -P ""
# copy ssh keys
sudo cp -r /root/.ssh /var/lib/jenkins/.ssh
sudo chown -R jenkins /var/lib/jenkins/.ssh
sudo chgrp -R jenkins /var/lib/jenkins/.ssh

echo "##########################################"
echo "# configure git                          #"
echo "##########################################"
sudo apt install -y git
git config --global user.name "jenkins@vagrant-fabric"
git config --global user.email "jenkins@conextrade.com"
sudo cp -r /root/.gitconfig /var/lib/jenkins/.gitconfig
sudo chown -R jenkins /var/lib/jenkins/.gitconfig
sudo chgrp -R jenkins /var/lib/jenkins/.gitconfig
sudo rm -r /root/.gitconfig

echo "##########################################"
echo "# install vagrant environment            #"
echo "#         - vagrant                      #"
echo "#         - virtualbox                   #"
echo "##########################################"
VAGRANT_VERSION="2.2.7"
# get keys
sudo wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian bionic contrib"
# install virtualbox
sudo apt update
sudo apt install -y virtualbox-6.1
# install vagrant
sudo wget -c https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb
sudo dpkg -i vagrant_${VAGRANT_VERSION}_x86_64.deb
sudo rm -f /home/vagrant/vagrant*.deb
# install vagrant plugin
vagrant plugin install vagrant-disksize
vagrant plugin install vagrant-hosts
vagrant plugin install vagrant-secret
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-vmware-esxi
# vagrant plugin install vagrant-serverspec
sudo cp -r /root/.vagrant.d /home/vagrant/.vagrant.d
sudo chown -R vagrant /home/vagrant/.vagrant.d
sudo chgrp -R vagrant /home/vagrant/.vagrant.d
sudo cp -r /root/.vagrant.d /var/lib/jenkins/.vagrant.d
sudo chown -R jenkins /var/lib/jenkins/.vagrant.d
sudo chgrp -R jenkins /var/lib/jenkins/.vagrant.d

echo "##########################################"
echo "# install ovftools                       #"
echo "##########################################"
echo "\n" | sudo TERM=dumb /bin/sh /vagrant/files/apps/ovftools/VMware-ovftool-4.3.0-7948156-lin.x86_64.bundle --eulas-agreed

# set timezone
sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
timedatectl

# create date string
DATE=`date +%Y%m%d%H%M`

# set version
FABRIC_VERSION=$(vboxmanage --version)
echo "virtualbox-$FABRIC_VERSION;vagrant-$VAGRANT_VERSION" > /vagrant/version
