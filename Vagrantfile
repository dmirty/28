# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant",type:"virtualbox"
  config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
  end
  
  config.ssh.username = "vagrant"

  config.vm.define "posgr1" do |posgr1|
    posgr1.vm.network "public_network", ip: "192.168.1.66"
    
    posgr1.vm.hostname = "posgr1.local"
  end

  config.vm.define "posgr2slave" do |posgr2slave|
    posgr2slave.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.cpus = 1
    end
    posgr2slave.vm.network "public_network", ip: "192.168.1.67"
    
    posgr2slave.vm.hostname = "posgr2slave.local"
  end



end
