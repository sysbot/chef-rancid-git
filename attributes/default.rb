
# basic attributes
default[:postfix][:enabled] = true
default[:rancid][:installed] = false
default[:rancid][:user] = 'rancid'
default[:rancid][:group] = 'rancid'
default[:rancid][:uid] = 2021
default[:rancid][:gid] = 2021

# in hourly unit
default[:rancid][:run_interval] = 1				# hourly
default[:rancid][:cleanup_interval] = 23	# daily at 23rd hour

default[:rancid][:prefix_dir] = "/home/rancid"
default[:rancid][:install_dir] = "#{node[:rancid][:prefix_dir]}"
default[:rancid][:key_dir] = "#{node[:rancid][:install_dir]}/keys"
default[:rancid][:local_state_dir] = "#{node[:rancid][:prefix_dir]}/var/rancid"

# fetch from remote git repo
default[:rancid][:url] = 'https://github.com/dotwaffle/rancid-git.git'
default[:rancid][:version] = 'af62ee744c0bb268fddb9715b57b6c60ec1463b0'

# configs
default[:rancid][:configs][:groups] = ["default"]
default[:rancid][:configs][:cloginrc] = {
  :user => "default",
  :method => "ssh",
  :password => "default",
  :identity => "#{node[:rancid][:prefix_dir]}/rancid",
  :pattern => "*"
}
