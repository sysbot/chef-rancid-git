#
# Cookbook Name:: rancid-git
# Recipe:: default
#
# Copyright 2013, Bao Nguyen
#
# All rights reserved
#
#

## rancid version that modified to work with git

# packages to support rancid
include_recipe "cron"

# packages needed by rancid to build and run
packages = {}
packages.merge!({
  'expect' => '',  
  'git' => '',
  'build-essential' => '',
  'autoconf' => '',
})

packages.each do |pkg_name, pkg_version|
  package pkg_name do
    action :install
    version pkg_version unless pkg_version.empty?
  end
end

# Rancid is going to run as a user, which query router configs
# we creating the user/group here

group node[:rancid][:group] do
  gid node[:rancid][:gid]
end

user node[:rancid][:user] do
  supports :manage_home => true
  comment "RANCID User"
  uid node[:rancid][:uid]
  gid {node[:rancid][:group]}
  home node[:rancid][:prefix_dir]
  shell "/bin/bash"
end


# we sync with the upstream rancid-git revision 3.8.1
if node.chef_environment == "dev"
   branch_name = "master"
else
   branch_name = node[:rancid][:version]
end

git "#{node[:rancid][:install_dir]}/rancid-git" do
  not_if do
    File.exist?("#{node[:rancid][:install_dir]}/.cloginrc")
  end
  # we use http so we can delay dealing with ssh_known_host manangement
  repository node[:rancid][:url]
  revision branch_name
  action :sync
  user node[:rancid][:user]
  group node[:rancid][:group]
end

# build and install rancid from source here
bash "build_install_rancid" do
  not_if do
    File.exist?("#{node[:rancid][:install_dir]}/etc/rancid.conf")
  end
  user node[:rancid][:user]
  group node[:rancid][:group]
  cwd "#{node[:rancid][:install_dir]}/rancid-git"
  code <<-EOF
    autoreconf
    ./configure --prefix=#{node[:rancid][:prefix_dir]} --localstatedir=#{node[:rancid][:install_dir]}/var/rancid && make install
  EOF
end

# install the cron job to run diff but doesn't do anything until it's setup with
# the routers/switch to query and groups etc.
cron_d "hourly-rancid-diff" do
  hour 1
  command "#{node[:rancid][:install_dir]}/bin/rancid-run"
  user node[:rancid][:user]
end

cron_d "daily-clean-up" do
  hour 23
  command "/usr/bin/find #{node[:rancid][:install_dir]}/var/rancid/logs -type f -mtime +2 -exec rm {} \;"
  user node[:rancid][:user]
end

