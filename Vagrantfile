# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.define "geocodr" do |geocodr|
    geocodr.vm.box = "ubuntu/trusty64"

  	geocodr.vm.hostname = "geocodr.local"
	geocodr.vm.network "private_network", ip: "192.168.33.101"

  	config.vm.provider :virtualbox do |vb|
        vb.name = "geocodr"
        vb.memory = 512
        vb.cpus = 1
    end

	geocodr.vm.provision "shell", path: "install.sh"
    end

end
