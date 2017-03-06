# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "boxcutter/debian8"
  config.vm.network "forwarded_port", guest: 8888, host: 8888
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.hostname = "dustproof-".concat(`hostname`).rstrip
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |v|
    v.memory = [[ENV['VAGRANT_MAX_VM_MEMORY'], 8192].compact.map{ |s| s.to_i }.min, 4092].max
    v.cpus = [ENV['VAGRANT_CPUS'], 4].compact.map{ |s| s.to_i }.max
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
  config.vm.provider :vmware_fusion do |v|
    v.vmx["memsize"] = [[ENV['VAGRANT_MAX_VM_MEMORY'], 8192].compact.map{ |s| s.to_i }.min, 4092].max.to_s
    v.vmx["numvcpus"] = "4"
  end

  config.vm.provision "shell", path: "provision/deploy.sh"
end
