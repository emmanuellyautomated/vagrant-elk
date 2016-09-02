# -*- mode: ruby -*-
# vi: set ft=ruby :

host_ip=`ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}' | tail -1`

env_var_cmd = ""
if host_ip
  value = host_ip
  env_var_cmd = <<CMD
echo "export HOST_IP=#{value}" | tee -a /home/vagrant/.profile
CMD
end

script = <<SCRIPT
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
    elk.vm.network "forwarded_port", host: 8080, guest: 80
    elk.vm.provision :shell, :inline => script
    elk.vm.provision :shell, path: "./provision.sh"
  end
end
