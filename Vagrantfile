# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |vagrant|
  vagrant.vm.define "gitlab" do |config|
    config.vm.box = "opscode-centos-7.0"
    config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
    config.vm.hostname = "gitlab.local.vm"
    config.vm.network "private_network", ip: "10.10.1.41"
    config.puppet_install.puppet_version = "3.7.3"

    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "default.pp"
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.module_path = ["puppet/modules", "puppet/vendor"]
    end

    config.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--cpus", "1" ]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
  end

  vagrant.vm.define "ci" do |config|
    config.vm.box = "opscode-centos-7.0"
    config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
    config.vm.hostname = "ci.local.vm"
    config.vm.network "private_network", ip: "10.10.1.42"
    config.puppet_install.puppet_version = "3.7.3"

    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "default.pp"
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.module_path = ["puppet/modules", "puppet/vendor"]
    end

    config.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--cpus", "1" ]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
  end

  vagrant.vm.define "puppet" do |config|
    config.vm.box = "opscode-centos-7.0"
    config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
    config.vm.hostname = "puppet.local.vm"
    config.vm.network "private_network", ip: "10.10.1.43"
    config.puppet_install.puppet_version = "3.7.3"

    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "default.pp"
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.module_path = ["puppet/modules", "puppet/vendor"]
    end

    config.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--cpus", "1" ]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
  end

  [1, 2, 3].each do |num|
    vagrant.vm.define "runner#{num}" do |config|
      config.vm.box = "opscode-centos-7.0"
      config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
      config.vm.hostname = "runner#{num}.local.vm"
      config.vm.network "private_network", ip: "10.10.1.5#{num}"
      config.puppet_install.puppet_version = "3.7.3"

      config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "default.pp"
        puppet.hiera_config_path = "puppet/hiera.yaml"
        puppet.module_path = ["puppet/modules", "puppet/vendor"]
      end

      config.vm.provider "virtualbox" do |vb|
        vb.memory = 1024
        vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--cpus", "1" ]
        vb.customize ["modifyvm", :id, "--ioapic", "on"]
      end
    end
  end

  [1, 2, 3].each do |num|
    vagrant.vm.define "host#{num}" do |config|
      config.vm.box = "opscode-centos-7.0"
      config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-7.0_chef-provisionerless.box"
      config.vm.hostname = "host#{num}.local.vm"
      config.vm.network "private_network", ip: "10.10.1.6#{num}"
      config.puppet_install.puppet_version = "3.7.3"

      config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "default.pp"
        puppet.hiera_config_path = "puppet/hiera.yaml"
        puppet.module_path = ["puppet/modules", "puppet/vendor"]
      end

      config.vm.provider "virtualbox" do |vb|
        vb.memory = 512
        vb.customize ["modifyvm", :id, "--memory", "512"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--cpus", "1" ]
        vb.customize ["modifyvm", :id, "--ioapic", "on"]
      end
    end
  end
end
