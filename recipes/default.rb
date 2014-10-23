#
# Cookbook Name:: rancid-git
# Recipe:: default
#
# Copyright 2013, Bao Nguyen
#
# All rights reserved
#

# packages to support rancid
include_recipe "rancid-git::_install"

# install the routers
node['rancid']['configs']['groups'].each do |g|
  puts "G: #{g}"
  search(:rancid, "id:\"#{g}\"").each do |n|
    puts "N: #{n}"
    puts "N-id: #{n[:id]}"
    puts "I: #{n[:routers][0][:name]}"
    rancid_git_router n[:id] do
      devices n[:routers]
    end
  end
end

# cloginrc
list = Array.new
node['rancid']['configs']['groups'].each do |g|
  puts "G: #{g}"
  search(:secrets, "id:\"#{g}\"").each do |n|
    list << n
  end
end

template "#{node[:rancid][:install_dir]}/.cloginrc" do
  source "cloginrc.erb"
  owner node[:rancid][:user]
  group node[:rancid][:group]
  mode "0644"
  variables(
    logins: list
  )
end

include_recipe "rancid-git::_cron"
