# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'securerandom'

#hostname = SecureRandom.hex(8)
hostname = "lxc"
domain   = "local"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu2104"
  config.vm.hostname = [hostname,domain].join('.')

  config.vm.synced_folder "../", "/src"

  config.vm.define :server do |server_config|
    server_config.vm.hostname = "server"
    server_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.customize ["modifyvm",  :id,  "--cpus",  "2"]
      vb.customize ["modifyvm",  :id,  "--ioapic",  "on"]
      # virtual box networking [1]
      # --nic<1-N> none|null|nat|bridged|intnet|hostonly|generic
      # --nictype<1-N> Am79C970A|Am79C973|82540EM|82543GC|82545EM|virtio 
      # --macaddress<1-N> auto|<mac>
      vb.customize ["modifyvm", :id, "--nic1", "nat", "--cableconnected1", "on"]
      vb.customize ["modifyvm", :id, "--nic2", "hostonly", "--nictype2", "82545EM", "--cableconnected2", "on", "--hostonlyadapter2", "vboxnet0"]
      # [1] http://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
    end

    server_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = ["~/chef/chef-repo/cookbooks", "~/chef/chef-repo/site-cookbooks"]
      chef.roles_path = "~/chef/chef-repo/roles"
      chef.data_bags_path = "~/chef/chef-repo/data_bags"
      chef.add_recipe "chef-solo-search"
      chef.add_role "base"
      chef.add_recipe "sshd::role-sysadmin"
      chef.add_recipe "rancid-git"
      
      chef.json = {
        'chef_client' => {
          'bin' => '/usr/local/bin/chef-client'
        },
        'region' => 'sv2',
        'fqdn'   => [hostname,domain].join('.'),
        'domain' => domain
      }
    end
  end
end
