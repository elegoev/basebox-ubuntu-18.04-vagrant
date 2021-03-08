# ubuntu-18.04-vagrant

Vagrant Box with Ubuntu 18.04 and vagrant

## Base image

Used base image [elegoev/ubuntu-18.04](https://app.vagrantup.com/elegoev/boxes/ubuntu-18.04)

## Directory Description

| directory | description                                          |
|-----------|------------------------------------------------------|
| inspec    | inspec test profiles with controls                   |
| packer    | packer build, provisioner and post-processor scripts |
| test      | test environment for provision & inspec development  |

## Vagrant 

### Vagrant Cloud

- [elegoev/ubuntu-18.04-vagrant](https://app.vagrantup.com/elegoev/boxes/ubuntu-18.04-vagrant)

### Vagrant Plugins

- [vagrant-disksize](https://github.com/sprotheroe/vagrant-disksize)
- [vagrant-hosts](https://github.com/oscar-stack/vagrant-hosts)
- [vagrant-secret](https://github.com/tcnksm/vagrant-secret)
- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
- [vagrant-serverspec](https://github.com/vvchik/vagrant-serverspec)
- [vagrant-vmware-esxi](https://github.com/josenk/vagrant-vmware-esxi)

### Vagrantfile

    Vagrant.configure("2") do |config|

      ENV['VAGRANT_EXPERIMENTAL'] = "disks"

      $basebox_name="ubuntu-18.04-vagrant-test"
      $basebox_hostname="ubuntu-1804-vagrant-test"
      $src_image_name="elegoev/ubuntu-18.04-vagrant"
      $vb_group_name="basebox-vagrant-test"

      config.vm.define "#{$basebox_name}" do |machine|
        machine.vm.box = "#{$src_image_name}"
    
        # define guest hostname
        machine.vm.hostname = "#{$basebox_hostname}"

        machine.vm.provider "virtualbox" do |vb|
          vb.name = $basebox_name
          vb.cpus = 2
          vb.customize ["modifyvm", :id, "--memory", "4096" ]
          vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
          vb.customize ["modifyvm", :id, "--groups", "/#{$vb_group_name}" ]
          vb.customize ["modifyvm", :id, "--nested-hw-virt", "on" ]
          vb.customize ["modifyvm", :id, "--vram", 256 ]
        end

        machine.vm.disk :disk, size: "40GB", primary: true
  
        # forwarding ports
        machine.vm.network "forwarded_port", id: "rdp",  auto_correct: true, protocol: "tcp", guest: 3389, host: 33333, host_ip: "127.0.0.1"

      end   

    end

### xRDP Issue

    xRDP is not working correctly, after 'vagrant up' try the following

    1. 'vagrant rdp' & login with ubuntu / ubuntu (black screen)
    2. Disconnect RDP Client
    3. 'vagrant rdp' & login with vagrant / vagrant

### Referenzen

- [How To Enable Nested Virtualization In VirtualBox](https://ostechnix.com/how-to-enable-nested-virtualization-in-virtualbox/)
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [phpVirtualBox](https://sourceforge.net/p/phpvirtualbox/wiki/Home/#setting-up-virtualbox)
- [How to Install Oracle VirtualBox On Ubuntu 18.04.2 LTS Headless Server](https://ostechnix.com/install-oracle-virtualbox-ubuntu-16-04-headless-server/)
- [RemoteBox](https://remotebox.knobgoblin.org.uk)
- [How to set up a VirtualBox remote GUI for easy VM management](https://www.techrepublic.com/article/how-to-set-up-a-virtualbox-remote-gui-for-easy-vm-management/)
- [How to install Virtualmin for a web-based VirtualBox dashboard](https://www.techrepublic.com/article/how-to-install-virtualmin-for-a-web-based-virtualbox-dashboard/)
- [webmin](https://www.webmin.com/)

### Versioning

Repository follows sematic versioning  [![semantic versioning](https://img.shields.io/badge/semver-2.0.0-green.svg)](http://semver.org)

### Changelog

For all notable changes see [CHANGELOG](https://github.com/elegoev/basebox-ubuntu-18.04-rancher/blob/main/CHANGELOG.md)

### License

Licensed under The MIT License (MIT) - for the full copyright and license information, please view the [LICENSE](https://github.com/elegoev/basebox-ubuntu-18.04-rancher/blob/main/LICENSE) file.

### Issue Reporting

Any and all feedback is welcome.  Please let me know of any issues you may find in the bug tracker on github. You can find it [here.](https://github.com/elegoev/basebox-ubuntu-18.04-rancher/issues)
