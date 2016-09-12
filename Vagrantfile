# -*- mode: ruby -*-
# vi: set ft=ruby :


host_ip=`ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}' | tail -1`

IP1 = "192.168.0.10"
IP2 = "192.168.0.20"

env_var_cmd = ""
if ENV['HOST_IP']
  value = ENV['HOST_IP']
  env_var_cmd = <<CMD
echo "export HOST_IP=#{IP1}" | tee -a /home/vagrant/.profile
CMD
end

$export_host_ip = <<SCRIPT
#{env_var_cmd}
SCRIPT

API_VERSION = "2"
Vagrant.configure(API_VERSION) do |config|
  config.vm.define "ELK" do |elk|
    elk.vm.box = "ubuntu/trusty64"
    elk.vm.provider "virtualbox" do |v|
      v.memory = 4072
      v.cpus = 2 
      v.customize ["modifyvm", :id, "--name", "elk"]
    end
    elk.vm.network "forwarded_port", guest: 9200, host: 9200 
    elk.vm.network :private_network, ip: "#{IP1}"
    elk.vm.provision :shell, inline: $export_host_ip
    elk.vm.provision :shell, path: "./provision.sh"
  end

  config.vm.define "NASANOMICS" do |nasanomics|
    nasanomics.vm.box = "debian/jessie64"
    nasanomics.vm.provider "virtualbox" do |v| 
      v.customize ["modifyvm", :id, "--name", "nasanomics"]
    end 
    nasanomics.vm.network :private_network, ip: "#{IP2}"
    nasanomics.vm.synced_folder "#{ENV['ELK_APP_1']}/", "/vagrant"
    nasanomics.vm.provision :shell, path: "#{ENV['ELK_APP_1_PROVISION']}"
  end
end
