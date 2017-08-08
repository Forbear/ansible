# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "sbeliakou/centos-7.3-x86_64-minimal"
    ansible.vm.network "forwarded_port", guest: 8080, host: 18080
    ansible.vm.network "private_network", ip: "192.168.100.101"
    ansible.vm.hostname = "ansible"
  
    ansible.vm.provider "virtualbox" do |vb|
      vb.name = ansible.vm.hostname
    ansible.vm.provision "file", source: "/home/student/.ssh/id_dsa.pub", destination: "key.pub"
    ansible.vm.provision "shell", path: "script.sh"
    end
  end
end
