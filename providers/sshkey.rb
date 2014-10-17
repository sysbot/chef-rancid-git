# Encoding: utf-8
# Cookbook Name:: rancid-git
# Provider:: sshkey
# Author:: Bao Nguyen
# License:: Apache 2.0
#
# Copyright 2014, Bao Nguyen

use_inline_resources

action :create do
  # Install sshkey gem into chef
  chef_gem 'sshkey'
  name = new_resource.name

  directory node['rancid']['key_dir'] do
    owner node['rancid']['user']
    group node['rancid']['group']
    mode 00700
  end

  pkey = "#{node[:rancid][:install_dir]}/keys/#{name}"
  unless ::File.exists?(pkey)
    # Generate a keypair with Ruby
    require 'sshkey'
    hostname = "localhost"

    sshkey = SSHKey.generate(
      type: 'RSA',
      bits: 4096,
      comment: "#{node['rancid']['user']}@#{hostname}"
    )

    # Store private key on disk
    file pkey do
      action :create_if_missing
      owner node['rancid']['user']
      group node['rancid']['group']
      mode "0600"
      content sshkey.private_key
    end

    # Store public key on disk
    file "#{pkey}.pub" do
      action :create_if_missing
      owner node['rancid']['user']
      group node['rancid']['group']
      mode "0600"
      content sshkey.ssh_public_key
    end
    new_resource.updated_by_last_action(true)
  end
end

action :remove do
  pkey = "#{node[:rancid][:install_dir]}/keys/#{new_resource.name}"
  Chef::Log.info "Removing sshkey #{new_resource.name.to_s}: to #{pkey}"

  if ::File.exists?(pkey)
    Chef::Log.info "SSH key #{new_resource.name.to_s}: to #{pkey}"
    file pkey do
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
end
