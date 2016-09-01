# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "ELK" do |elk|
    elk.vm.box = "ubuntu/trusty64"
    elk.vm.provider "virtualbox" do |v|
      v.memory = 4072
      v.cpus = 2 
      v.customize ["modifyvm", :id, "--name", "elk"]
    end
    elk.vm.network "forwarded_port", host: 8080, guest: 80
    elk.vm.provision :shell, path: "./provision.sh"
  end
end
