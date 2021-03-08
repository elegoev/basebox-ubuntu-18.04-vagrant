#!/bin/bash

application_file_path="/vagrant/installed-application.md"


# check lock file
if [ -f "/var/lib/dpkg/lock-frontend" ]; then
  sudo rm -f /var/lib/dpkg/lock-frontend
fi
if [ -f "/var/lib/dpkg/lock" ]; then
  sudo rm -f /var/lib/dpkg/lock
fi

# remove unattended upgrades
sudo apt remove unattended-upgrades

# install jq
sudo apt-get install -y jq

# install jfrog
sudo curl -s -fL https://getcli.jfrog.io | sh
sudo chmod +x jfrog
sudo mv jfrog /bin/jfrog

# install git
sudo apt-get install -y jq
git config --global user.name "developer@test.org"exitvagarnt
git config --global user.email "developer@test.org"
sudo rm -r /root/.gitconfig

# install virtualbox
sudo wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian bionic contrib"
sudo apt update

# check lock file
if [ -f "/var/lib/dpkg/lock-frontend" ]; then
  sudo rm -f /var/lib/dpkg/lock-frontend
fi
if [ -f "/var/lib/dpkg/lock" ]; then
  sudo rm -f /var/lib/dpkg/lock
fi

sudo apt install -y virtualbox-6.1
sudo usermod -aG vboxusers vagrant

# Install VirtualBox Extension pack
extension_version="6.1.18"
wget https://download.virtualbox.org/virtualbox/${extension_version}/Oracle_VM_VirtualBox_Extension_Pack-${extension_version}.vbox-extpack
sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${extension_version}.vbox-extpack \
                --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c


# install vagrant
vagrant_version="2.2.14"
sudo wget -q -c https://releases.hashicorp.com/vagrant/${vagrant_version}/vagrant_${vagrant_version}_x86_64.deb
sudo dpkg -i vagrant_${vagrant_version}_x86_64.deb
sudo rm -f /home/vagrant/vagrant*.deb
# install vagrant plugin
vagrant plugin install vagrant-disksize
vagrant plugin install vagrant-hosts
vagrant plugin install vagrant-secret
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-vmware-esxi
vagrant plugin install vagrant-serverspec
sudo cp -r /root/.vagrant.d /home/vagrant/.vagrant.d
sudo chown -R vagrant /home/vagrant/.vagrant.d
sudo chgrp -R vagrant /home/vagrant/.vagrant.d

# install vmware tools
vmware_tools_version="4.4.1-16812187"
echo "\n" | sudo TERM=dumb /bin/sh /home/vagrant/files-prov/ovftools/VMware-ovftool-${vmware_tools_version}-lin.x86_64.bundle --eulas-agreed

# set timezone
sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
timedatectl

# set version
OVF_TOOLS_VERSION=$(ovftool --version | awk  '{print $3}')
VIRTUALBOX_VERSION=$(vboxmanage --version)
JFROG_VERSION=$(jfrog --version | awk  '{print $3}')
GIT_VERSION=$(git version | awk  '{print $3}')
VAGRANT_VERSION=$(vagrant version | grep Installed | awk  '{print $3}')
echo "# Installed application "  > $application_file_path
echo "***                     " >> $application_file_path
echo "> OVF Tools: ${OVF_TOOLS_VERSION}" >> $application_file_path
echo "> Git: ${GIT_VERSION}" >> $application_file_path 
echo "> JFrog: ${JFROG_VERSION}" >> $application_file_path 
echo "> VirtualBox: $VIRTUALBOX_VERSION" >> $application_file_path
echo "> Vagrant: $VAGRANT_VERSION" >> $application_file_path


