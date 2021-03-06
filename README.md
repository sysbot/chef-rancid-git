rancid-git Cookbook
===================
This cookbook download rancid-git fork by "dotwaffle" which support git as the
backend for configuration management.

Requirements
------------
Since this cookbook compiles rancid-git from source the build-essential and git
is required to be installed. I've only test this on Ubuntu 12.04

You will still need to install a MTA to send emails from the rancid machine.

To securely store and manage the remote devices. You will need chef-vault
to manage the credential that's going to be deploy on the machine.

Attributes
----------

These default attributes are set. You can change them to suit your needs.

##### basic attributes
default[:postfix][:enabled] = true
default[:rancid][:user] = 'rancid'
default[:rancid][:group] = 'rancid'
default[:rancid][:uid] = 2021
default[:rancid][:gid] = 2021

##### in hourly unit
default[:rancid][:run_interval] = 1       # hourly
default[:rancid][:cleanup_interval] = 23  # daily at 23rd hour

##### local setup path
default[:rancid][:prefix_dir] = '/home/rancid'
default[:rancid][:install_dir] = '/home/rancid'
default[:rancid][:local_state_dir] = "#{node[:rancid][:prefix_dir]}/var/rancid"

##### fetch from remote git repo
default[:rancid][:url] = 'https://github.com/dotwaffle/rancid-git.git'
default[:rancid][:version] = 'af62ee744c0bb268fddb9715b57b6c60ec1463b0'

Usage
-----

#### Build a databag with the following format for hosts in eatch group
```json
{
  "id": "sjc1",
  "routers": [
    {
      "name": "router1.company.com",
      "model": "juniper",
      "status": "up"
    },
    {
      "name": "router2.company.com",
      "model": "juniper",
      "status": "up"
    }
  ]
}
```

#### Build a databag with the following data and format for cloginrc


#### rancid-git::default
Just include `rancid-git` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rancid-git]"
  ]
}
```
Note that by default, it will only install RANCID. You still need to configure
rancid.conf, .cloginrc and /etc/aliases to make rancid fully functional.

#### rancid-git::secrets
Will generate a new SSH key to be used to deploy to the routers/switches. It
also has the code to retreive secrets from data bag items encrypted with chef-vault.

Contributing
------------

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

Authors: Bao Nguyen
