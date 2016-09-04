# -*- mode: ruby -*-
# vi: set ft=ruby :


host_ip=`ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}' | tail -1`

env_var_cmd = ""
if ENV['HOST_IP']
  value = ENV['HOST_IP']
  env_var_cmd = <<CMD
echo "export HOST_IP=#{host_ip}" | tee -a /home/vagrant/.profile
CMD
end

export_host_ip = <<SCRIPT
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
    elk.vm.network "forwarded_port", host: 8888, guest: 80
    elk.vm.provision :shell, inline: export_host_ip
    elk.vm.provision :shell, path: "./provision.sh"
  end
end
