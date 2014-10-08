# Encoding: utf-8
# Cookbook Name:: rancid-git
# Provider:: router
# Author:: Bao Nguyen
# License:: Apache 2.0
#
# Copyright 2014, Bao Nguyen

use_inline_resources

action :remove do
  db_file = "#{node[:rancid][:install_dir]}/var/#{@name}/router.db"
  Chef::Log.info "Removing router db #{new_resource.name.to_s}: to #{db_file}"

  if ::File.exists?(db_file)
    Chef::Log.info "Removing router db #{new_resource.name.to_s}: to #{db_file}"
    file db_file do
      action :delete
    end
    new_resource.updated_by_last_action(true)
  end
end

action :create do
  var = "#{node[:rancid][:install_dir]}/var"
  group = "#{var}/#{new_resource.name}"
  db_file = "#{group}/router.db"

  directory var do
    owner node[:rancid][:user]
    group node[:rancid][:group]
    mode "0755"
    action :create
  end

  directory group do
    owner node[:rancid][:user]
    group node[:rancid][:group]
    mode "0755"
    action :create
  end

  template db_file do
    source "routers.db.erb"
    owner node[:rancid][:user]
    group node[:rancid][:group]
    mode "0644"
    variables(
      devices: new_resource.devices
    )
  end
  Chef::Log.info "Building router db #{new_resource.name.to_s}: to #{db_file}"
  new_resource.updated_by_last_action(true)
end
